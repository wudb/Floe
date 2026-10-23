# 布局导入：格式与验证边界

本批只迁移对应应用的分区及相对顺序，不导入行为设置、权限、快捷键、许可证、脚本、链接或小组件。入口位于设置 → 导入布局；当前属于开发版本，尚未随已发布的 v1.0.2 提供。

| 来源 | 当前实现 | 尚未验证的边界 |
| --- | --- | --- |
| Ice | 读取当前原生菜单栏中 `com.jordanbaird.Ice` 的 `HItem` / `AHItem` 分隔符，保留同一菜单栏图标的左右顺序；读取后退出 Ice，再刷新预览并导入 | 未运行或系统无法读取的项目无法从偏好文件恢复；多屏、折叠与真实迁移需实机验收 |
| Bartender | 解码 JSON / XML / binary plist 的 `ProfileSettings.activeProfile`；`Show` → 可见，`Hide` → 隐藏，`AlwaysHide` → 始终隐藏 | 新版独立备份/压缩格式、所有历史版本、数组左右方向需真实导出验收；预览允许反转顺序 |
| Barbee | 辅助读取 JSON / plist 中显式应用字段的有序数组，由用户选择列表及目标分区 | 尚无真实厂商导出样例，不能宣称兼容其所有备份；不解密、不猜测私有枚举 |
| ExtraBar | 辅助读取导出的 JSON 中应用数组，由用户选择预设对应列表及目标分区 | 官方文档未公开完整 JSON schema；已核查 1.7.2 官方包中的 `bundleID`、`items` 等模型字段，但不是端到端导出验收；无原生状态项的启动器应用只会保留待匹配记录 |

## 读取与匹配

- 文件最多 10 MiB；有序数组最多 2,000 项；扫描深度最多 12，最多检查 20,000 个节点、返回 100 个候选列表。
- 辅助格式识别字符串 Bundle Identifier 数组，或含 `bundleIdentifier` / `bundleID` / `bundleId` / `appBundleIdentifier` 的记录数组。plist 中的 Data 仅尝试 JSON 解码；不执行内容，不递归解释脚本字符串，不从无序字典推导顺序。
- 源数组顺序作为候选左右顺序，用户可反转或移除记录。辅助模式不自动猜分区或 `position` 字段的含义，也不合并多个预设。
- 单图标应用使用 Bundle Identifier；多图标必须精确匹配稳定标题。`Item-N` 不能区分同一宿主的多个图标；运行但身份不明的宿主不会被当作“未运行应用”。
- Bartender 的 `bundle-token` 只用当前原生宿主或 Launch Services 可核实的最长 Bundle Identifier 匹配；不按第一个连字符拆分。不认识的特殊 token 不会扩展为所有应用规则。
- 同一目标身份重复出现时全部标记为冲突，由用户移除多余记录后再选择。系统保护项、不可隐藏项及“始终可见”规则冲突会明确跳过，规则本身不变。

## 保存、恢复与回退

提交前重新成功读取原生布局，比较环境、已保存选择版本、图标身份、分区顺序及应用规则。预览过期则拒绝写入，用户需要刷新。无效/空选择不会建立基线或覆盖备份。

通过验证后，以当前真实布局建立导入前备份，再整批保存；未运行宿主的已有记录继续保留。导入应用按各分区源顺序排在开头，其余应用保留分区和相对顺序。此策略避免将新应用排列在不可移动的系统时钟之后。

实际移动复用已有布局恢复管线，包含菜单/用户输入保护、窗口及 PID 重验、落点读回、取消及重试退避。未运行应用及禁用分区保留待办。离开页面或点击取消可取消当前操作；已经提交的布局不会因取消丢失，可显式撤销。

备份保存在 Floe 自身偏好的 `MenuBarLayoutImportBackup.v1`，跨重启保留；每次成功导入替换上一份备份。撤销重放备份，不更改来源工具配置。界面在应用及撤销前检查 Ice、Barbee、ExtraBar、Bartender 是否仍运行，避免同时管理图标。

## 本批验证

- `script/tests/layout-import.swift`：生产解析器/匹配器；Bartender 三分区、JSON/binary plist、辅助列表、脚本/URL 排除、嵌入 JSON、体积边界、带连字符的宿主、多图标、重复与规则冲突。
- `script/tests/layout-persistence.swift`：生产存储与管理器方法；整批保存、未提及顺序、无效写入拒绝、跨重启撤销、新快照与规则校验、Ice 分隔符读取，以及已有取消/恢复回归。
- `script/tests/new-item-rules.swift`、`app-language.swift`：既有规则与双语资源。
- Debug / Release 编译及严格 SwiftLint。

受控测试不等于真实迁移验收。后续需要四款工具的真实导出/运行环境，覆盖多屏、多个状态项、源工具退出、未运行宿主回归，以及部分移动失败后继续/撤销。

## 格式证据

- [SaneBar 的 Ice 导入实现](https://github.com/sane-apps/SaneBar/blob/main/Core/Services/IceImportService.swift)：解释 Ice 偏好不持久化逐图标布局。Floe 当前 Ice 读取方式另以自身继承的原生分隔符标识为依据。
- [SaneBar 的 Bartender 导入实现](https://github.com/sane-apps/SaneBar/blob/main/Core/Services/BartenderImportService.swift)：核对 `ProfileSettings/activeProfile` 与三个数组键；本批独立实现，不复制行为设置迁移。
- [ExtraBar 官方预设文档](https://extrabar.app/docs/presets)：预设导出 JSON，可导出多个预设或单应用配置；Floe 只读取应用列表。
- [ExtraBar 官方下载](https://github.com/AppitStudio/extra-bar-updates/releases/download/beta/ExtraBar.dmg)：只读检查 1.7.2 包资源及模型字段，未安装或启动。
- [Apple 的 Barbee 应用信息](https://itunes.apple.com/lookup?id=1548711022&entity=macSoftware)：核实应用身份 `com.HyperartFlow.Barbee`，不是备份 schema 的证据。
