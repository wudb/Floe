# M4 外观与常态性能优化审计

日期：2026-10-14。M4 共 40 条（V1 36、V2 4）。通过主机已有 GitHub 授权刷新全部原文及完整分页评论，40 条目前均为 open，保留在 [原文快照](m4-upstream-review.json)。[机器状态](m4-status.json) 区分本批代码改进、原场景待复现和未实现的扩展能力。没有删除 issue，M4 及总清单数量不变。

## 本批修复

- **颜色选择器（jordanbaird/Ice#763）**：旧 KVO 在颜色控件创建时发布默认颜色，并异步写回 Binding，程序设置也进入同一反馈路径。改用连续 target/action，只响应用户操作；SwiftUI 更新时同步最新 Binding 和面板选项；销毁时清除 target/action 和观察者。真实 NSColorWell 回归验证初始化及程序修改不写回、用户操作写入、Binding 替换和销毁清理。
- **吸管（#763）**：外观编辑器的全局外部点击监听会关闭弹窗及共享颜色面板。颜色面板可见时保留编辑会话，避免在其他应用取色时中断；颜色面板关闭后恢复普通外部点击关闭，显式关闭编辑器/切换 Space 的清理保留。上游评论称 dev.2 已改善，本次仍针对 Floe 自身代码定位，不直接推断上游已修复全部问题。
- **背景 tint（#651）**：布局/浮栏的样式修饰器以前在整个内容上 overlay 色调；改为背景内部组合，前景图标和文字不再被 tint 覆盖。已有透明度控制保持原语义。原生菜单栏/Mission Control 的整项需求仍须单独验收；#793 的截图对比度问题也不能据此宣告解决。
- **鼠标订阅（#334、#479、#578、#830）**：原 mouseMoved 始终订阅，只在每次调用悬停处理后提前返回；关闭悬停时现在直接注销本地/全局订阅，设置变化时动态启停。点击、滚动、拖动监视独立保留，停止管理器后设置变化不能重新启动监听。上游性能评论明确提到关闭悬停时的移动事件成本；本次不采用评论中的 CPU 数字作为 Floe 测量。
- **外观周期工作（V2）**：隐藏、透明、已移除面板跳过周期绘制；AX 状态区边缘检查仅用于可见 split；收缩动画下一帧检测到失效即停止。定时器仍有唤醒，未宣称消除全部闲置开销。60 秒合成 tick 对照验证隐藏面板工作次数为零，full/none 不作状态区 AX 检查，此证据不是 CPU 或能耗测量。
- **间距操作（#472）**：旧退出 KVO 在应用拒绝强制退出时永远不恢复 continuation，使操作永久挂起。改为最多约三秒有界等待，强制退出仅调用一次，并传播取消；取消操作不继续启动后续应用重启。命令仍为报告所列 currentHost/globalDomain 的系统偏好路径。回归模拟普通退出、强制退出、拒绝退出与取消，不写系统偏好或退出真实用户应用。

## 验证与边界

新增五项生产逻辑/原生控件回归；已有 33 项回归通过，新增项分别验证颜色写回、吸管外部点击、鼠标订阅、外观工作门禁和退出期限。最终 Debug、Release 构建及严格 SwiftLint 结果见本次执行日志（/tmp/Floe-M4-*.log）。所有构建只证明编译，没有证明 Tahoe 像素表现或能源收益。

此前 [Floe 原生诊断](m3-evidence/floe-runtime-diagnostics.json) 记录主机 macOS 15.8.1、三屏及 Floe 缺少 AX/屏幕录制权限；本批未触发权限申请或改动系统显示/间距设置。未对外观操作生成真机主题/壁纸/Spaces 截图，未执行真实运行状态的启停 CPU/能耗对照与线程采样。因此 M4 整体验收未完成。GIF、SF Symbols、自定义刷新率、分区样式及新的圆角/clear 形状等能力仍未实现，不把“核对”记为完成。

## 逐条剩余验收

| issue | 工作包 | 本批状态 | 剩余验收 |
| --- | --- | --- | --- |
| [jordanbaird/Ice#58](https://github.com/jordanbaird/Ice/issues/58) | V1 | 已核对，待复现 | macOS 14.4.1 的多种 Space 切换录像及闪烁对照 |
| [jordanbaird/Ice#194](https://github.com/jordanbaird/Ice/issues/194) | V1 | 已核对，待复现 | 移出屏幕的图标拖动后透明度恢复；真实菜单布局截图 |
| [jordanbaird/Ice#212](https://github.com/jordanbaird/Ice/issues/212) | V1 | 已核对，待复现 | 跨桌面拖动后立即关闭/重开浮栏，验证 M3 颜色代次的实际视觉表现 |
| [jordanbaird/Ice#239](https://github.com/jordanbaird/Ice/issues/239) | V1 | 已核对，待复现 | 刘海屏长菜单、全屏及 Mission Control 三种裁切场景 |
| [jordanbaird/Ice#397](https://github.com/jordanbaird/Ice/issues/397) | V1 | 已核对，待复现 | 启用 always-hidden 后展开隐藏区，核实实际 Dock 图标及激活策略 |
| [jordanbaird/Ice#409](https://github.com/jordanbaird/Ice/issues/409) | V1 | 已核对，待复现 | 登录启动时系统菜单栏晚出现的边框恢复；需重启登录验证 |
| [jordanbaird/Ice#435](https://github.com/jordanbaird/Ice/issues/435) | V1 | 已核对，待复现 | Cmd+Option+D 显隐 Dock 的录像对照 |
| [jordanbaird/Ice#472](https://github.com/jordanbaird/Ice/issues/472) | V1 | 代码改进，待原场景 | 真实偏好写入、应用重启或重新登录后的系统间距；本次只证明等待不挂起 |
| [jordanbaird/Ice#510](https://github.com/jordanbaird/Ice/issues/510) | V1 | 已核对，待复现 | 无刘海屏顶端 1–2 像素间隙的真实截图和样式约定 |
| [jordanbaird/Ice#514](https://github.com/jordanbaird/Ice/issues/514) | V1 | 已核对，待复现 | 单窗口/多窗口 App Exposé 的阴影动画 |
| [jordanbaird/Ice#525](https://github.com/jordanbaird/Ice/issues/525) | V1 | 已核对，待复现 | macOS 15.3.2 外观图层实际效果 |
| [jordanbaird/Ice#541](https://github.com/jordanbaird/Ice/issues/541) | V1 | 已核对，待复现 | 多屏扩展时关闭设置窗口后的 split 外观；M3 生命周期已改进但尚无视觉验收 |
| [jordanbaird/Ice#608](https://github.com/jordanbaird/Ice/issues/608) | V1 | 已核对，待复现 | HDMI/USB-C 外屏右段空白的像素范围和状态区测量 |
| [jordanbaird/Ice#625](https://github.com/jordanbaird/Ice/issues/625) | V1 | 已核对，待复现 | 隐藏浮栏仅少量图标时的实际宽度 |
| [jordanbaird/Ice#627](https://github.com/jordanbaird/Ice/issues/627) | V1 | 已核对，待复现 | 原机器所有 shape 都无外观的复现与图层检查 |
| [jordanbaird/Ice#645](https://github.com/jordanbaird/Ice/issues/645) | V1 | 已核对，待复现 | 持续运行 30–45 分钟以上的闪烁录像及采样 |
| [jordanbaird/Ice#649](https://github.com/jordanbaird/Ice/issues/649) | V1 | 已核对，待复现 | 点击壁纸显示桌面时 split 蒙版/阴影动画 |
| [jordanbaird/Ice#651](https://github.com/jordanbaird/Ice/issues/651) | V1 | 代码改进，待原场景 | 实际原生菜单栏背景/图标分层、透明度和 Mission Control；本次仅修正浮栏/布局视图的 tint |
| [jordanbaird/Ice#659](https://github.com/jordanbaird/Ice/issues/659) | V1 | 已核对，待复现 | Tahoe 26 顶端阴影像素对照 |
| [jordanbaird/Ice#676](https://github.com/jordanbaird/Ice/issues/676) | V1 | 已核对，待复现 | Tahoe split 右段左侧空白的 AX 几何核对 |
| [jordanbaird/Ice#728](https://github.com/jordanbaird/Ice/issues/728) | V1 | 已核对，待复现 | Chevron 与竖线分隔符显隐规则及实际拖动对照 |
| [jordanbaird/Ice#733](https://github.com/jordanbaird/Ice/issues/733) | V1 | 已核对，待复现 | macOS 14.4.1 悬停展开时随机像素化录像 |
| [jordanbaird/Ice#763](https://github.com/jordanbaird/Ice/issues/763) | V1 | 代码改进，待原场景 | macOS 26.0.1 色轮、连续滑块、吸管实际交互及 Reduce Transparency 场景 |
| [jordanbaird/Ice#793](https://github.com/jordanbaird/Ice/issues/793) | V1 | 已核对，待复现 | macOS 26.1 布局图标截图的亮暗对比；背景 tint 改进不能代替图标对比度修复 |
| [jordanbaird/Ice#943](https://github.com/jordanbaird/Ice/issues/943) | V1 | 已核对，待复现 | macOS 26.4 blur/tint 与系统主题亮度截图 |
| [jordanbaird/Ice#334](https://github.com/jordanbaird/Ice/issues/334) | V2 | 代码改进，待原场景 | 同环境悬停启停、高轮询率鼠标移动的 CPU/能耗和线程采样 |
| [jordanbaird/Ice#479](https://github.com/jordanbaird/Ice/issues/479) | V2 | 代码改进，待原场景 | 同环境常态 CPU/能耗对照；不能由减少 AX 工作推断电池收益 |
| [jordanbaird/Ice#578](https://github.com/jordanbaird/Ice/issues/578) | V2 | 代码改进，待原场景 | 动态流量图标/应用菜单变化的 CPU 对照和线程采样 |
| [jordanbaird/Ice#830](https://github.com/jordanbaird/Ice/issues/830) | V2 | 代码改进，待原场景 | macOS 15.7.3 温度/CPU 原始复现，不能将笼统报告视为全部修复 |
| [jordanbaird/Ice#186](https://github.com/jordanbaird/Ice/issues/186) | V1 | 能力待实现 | GIF 状态项动画能力未实现，需限定帧率和后台成本 |
| [jordanbaird/Ice#245](https://github.com/jordanbaird/Ice/issues/245) | V1 | 能力待实现 | 自定义展开/收起 SF Symbol 名称未实现 |
| [jordanbaird/Ice#273](https://github.com/jordanbaird/Ice/issues/273) | V1 | 能力待实现 | 用户可配置图像刷新率未实现；需定义速率和能耗约束 |
| [jordanbaird/Ice#368](https://github.com/jordanbaird/Ice/issues/368) | V1 | 能力待实现 | 隐藏/始终隐藏区独立样式未实现 |
| [jordanbaird/Ice#380](https://github.com/jordanbaird/Ice/issues/380) | V1 | 能力待实现 | 阴影与其他窗口标题栏的层级及实际截图 |
| [jordanbaird/Ice#468](https://github.com/jordanbaird/Ice/issues/468) | V1 | 能力待实现 | M3 默认全屏隐藏外观已实现；独立全屏样式配置未实现，需视觉验收 |
| [jordanbaird/Ice#482](https://github.com/jordanbaird/Ice/issues/482) | V1 | 能力待实现 | 顶角/负空间/屏幕底角的新样式能力未实现 |
| [jordanbaird/Ice#533](https://github.com/jordanbaird/Ice/issues/533) | V1 | 能力待实现 | 可配置顶部浮动间隙未实现，与 #510 的贴顶诉求需并存 |
| [jordanbaird/Ice#538](https://github.com/jordanbaird/Ice/issues/538) | V1 | 能力待实现 | 系统点击高亮圆角由系统绘制，尚无可靠兼容实现 |
| [jordanbaird/Ice#705](https://github.com/jordanbaird/Ice/issues/705) | V1 | 能力待实现 | 彻底清除系统菜单栏灰色背景的 clear shape 未实现 |
| [jordanbaird/Ice#754](https://github.com/jordanbaird/Ice/issues/754) | V1 | 能力待实现 | macOS 暗色应用图标资源和系统兼容范围尚未实现 |
