# C3 权限检测与启动授权核对

核对日期：2026-10-14。范围为 M1/C3 的 3 条保留报告。通过主机已有 GitHub 授权刷新原文和全部评论，存于 [实时核对快照](c3-upstream-review.json)，逐条机器状态见 [C3 状态](c3-status.json)。三条均为 open，未修改上游状态。

## 本批代码修复

- `Permission.waitForPermission` 原实现将唯一 Combine 订阅保存在实例字段中。重复请求会覆盖旧订阅，使旧 continuation 无人恢复；任务取消也无法退出。本批按 UUID 登记独立 continuation，全部等待者共享实例现有的 1 秒检测。取消仅移除当前等待者；注册前取消、授权与取消竞争均检查取消状态，避免漏恢复或重复恢复。
- `PermissionsView` 按权限保留等待任务，重复点击先取消同权限旧任务；窗口关闭、跳过或视图退出时取消所有等待。取消后的旧任务不会重新激活应用和打开授权窗口。不同权限的等待互不覆盖。
- 必需权限授权后会停止周期检查。现加入应用激活观察，返回 Floe 时重新检查授权，避免系统设置已变更但高级设置/权限页面仍显示旧值。检测到撤权后恢复共享定时检查，后台再次授权也能被发现；启动定时器为幂等操作，使用 common run-loop mode，避免菜单跟踪期间暂停。只有实际变化才发布。屏幕录制继续复用现有有期限缓存；此次不将系统 TCC 真值替换为人工状态。

## 逐条结论

| 报告 | 证据与适用性 | 当前状态及剩余条件 |
| --- | --- | --- |
| [jordanbaird/Ice#770](https://github.com/jordanbaird/Ice/issues/770) | 描述为授权后卡住；[评论](https://github.com/jordanbaird/Ice/issues/770#issuecomment-3562648064)明确为 M5 的 Auto Update 屏幕。Floe 已在 `UpdatesManager.updaterShouldPromptForPermissionToCheck` 返回 false，且自身 feed/key 未配置前不启动 updater。 | 已有防护；本批不把权限等待修复宣称为其根因。需对应 Tahoe/M5 首次安装验收，继续保留。 |
| [jordanbaird/Ice#834](https://github.com/jordanbaird/Ice/issues/834) | Sequoia 15.8.1 重启后每天反复弹出权限相关对话框；评论仅提供非官方构建线索，未给出确认根因。 | 授权任务重入/退出和返回应用刷新已修复，但尚无证据证明这些缺陷就是原报告原因。需确认系统或应用弹窗来源、签名身份、真实授权及重启数小时后的行为。 |
| [jordanbaird/Ice#934](https://github.com/jordanbaird/Ice/issues/934) | Tahoe 26.4.1 启动看似无反应；[评论](https://github.com/jordanbaird/Ice/issues/934#issuecomment-4325110740)表示连接外接 27 英寸屏后可见，配置布局仍异常。 | 不能只凭启动症状归因于权限。需内置/外接屏及显示空间对照，结合 C2 发现链路记录；根因未确认，继续保留。 |

## 验证与边界

当前主机 macOS 15.8.1、Xcode 26.3。Debug 和 Release 编译均通过；全部 20 个 Swift 回归脚本通过；SwiftLint strict 检查 117 个文件、0 violations；`git diff --check` 通过。

新增 `script/tests/permission-wait-lifecycle.swift` 直接编译生产 Permission 实现，使用可控检查闭包验证：两次未授权等待中取消一个不影响另一个；等待者不单独轮询；已授权重复等待可完成；停止轮询后应用激活能发现撤权，随后无需再次激活便可发现后台重新授权；多个未授权等待者同时完成；预先取消的调用即使已经授权也退出。该回归不调用真实授权请求、不修改系统设置。

日志：`/tmp/Floe-C3-Debug.log`、`/tmp/Floe-C3-Release.log`、`/tmp/Floe-C3-regression.log`、`/tmp/Floe-C3-lint.log`。

本批没有重置 TCC、修改第三方授权或签名，也没有 macOS 26/27 真机验收。受控测试不证明 SwiftUI 窗口及系统对话框的实际交互；系统授权 API 阻塞、签名漂移和系统重复提示未据此宣称解决。三条原始报告和全部原始快照数据保留，C3 仍为 3 条、M1 70 条、总清单 367 条。

## 后续优化：申请前核实真实状态

`Permission.performRequest` 在系统请求及打开设置前刷新当前授权。界面尚未同步、但权限已在系统设置授予时，直接返回，不再重复请求。生产回归覆盖真实未授权请求、已授权请求及旧界面误判三种情况。未修改 TCC 或系统提示规则；#834 的每日重启后重复对话框仍需原环境验收。

后续验证日志：`/tmp/Floe-C34-Debug.log`、`/tmp/Floe-C34-Release.log`、`/tmp/Floe-C34-regression.log`、`/tmp/Floe-C34-lint.log`。
