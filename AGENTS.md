# 项目协作说明

## 仓库来源与 Fork 关系

本项目为 Floe，仓库地址：https://github.com/wudb/Floe。

Fork 链路（从原始项目到本项目）：

```text
jordanbaird/Ice → cavaldos/Ice → wudb/Floe
```

- 原始上游：https://github.com/jordanbaird/Ice。
- 直接上游：https://github.com/cavaldos/Ice，fork 自 `jordanbaird/Ice`。
- 本项目：https://github.com/wudb/Floe，fork 自 `cavaldos/Ice`。
- 当前本地 Git remote：`origin` 指向 `wudb/Floe`，`upstream` 指向 `cavaldos/Ice`。使用前通过 `git remote -v` 核对实时配置。
- 对比上游代码、引用 issue 或记录修复来源时，写明完整仓库名和编号（如 `cavaldos/Ice#9`），避免不同仓库的编号混淆。

## 访问要求

1. 采用主机环境访问 GitHub，复用主机已有的 GitHub 授权。
2. 访问 Apifox 时不要挂代理。

## 上游问题资料

- `docs/upstream-open-issues.md`：两个上游仓库采集的 open issues 中，排除本项目已确认修复或满足需求条目后的原始标题、正文、元数据和链接。
- `docs/upstream-open-issues-summary.md`：分类数量、逐条分类索引、相似问题线索和对 Floe 的排查建议。
- `docs/upstream-open-issues.snapshot.json`：机器可读保留清单，保留未删除条目的 GitHub API 数据及本地筛选元信息。
- `docs/upstream-issue-fix-audit.md`：本地删除条目的理由、源码依据和验证边界。
- `docs/issues_milestone.md`：保留 issues 的 P0–P3 优先级、M0–M5 里程碑、工作包、依赖及验收条件；处理条目后同步更新其索引和数量。
- 资料基于采集时点快照，已按本项目实现筛选；数量不等同于上游实时 open 总数。开始处理某条 issue 前，重新确认其当前状态、关联修复和本项目是否可复现；不要仅根据 open 状态判断 Floe 存在相同问题。

## Floe 工程命名

- Xcode 工程：`Floe.xcodeproj`；Target 和共享 Scheme：`Floe`。
- 源码目录：`Floe/`；应用与发布产物：`Floe.app`、`Floe.zip`、`Floe.dmg`。
- Bundle Identifier：`com.wudb.Floe`，与上游 Ice 的偏好设置和系统隐私授权独立。
- 项目 UI、类型和脚本统一采用 Floe 命名；上游仓库名、历史 issue 原文、版权归属及 Ice Cube 图标形状名称保留。
- 自动更新必须使用 Floe 自己的更新源和签名公钥；未配置前不启用 Sparkle，也不向上游发布更新。

## 本地化

- 默认跟随系统首选语言，支持英语和简体中文；未支持语言回退英语。
- `LanguageManager` 保存选择并更新 SwiftUI 语言环境；独立窗口、浮栏和 Popover 的根视图需接入 `.appLanguage()`。
- SwiftUI 文案使用本地化键，AppKit 菜单、弹窗和错误使用 `L10n.string`；两个 `.lproj/Localizable.strings` 同步维护，持久化标识和第三方应用名称不翻译。
- README 默认英语，`README.zh-CN.md` 为简体中文版，导航和功能说明同步更新。
- 验证语言匹配与格式化使用 `swift script/tests/app-language.swift`，不修改系统 AppleLanguages。
