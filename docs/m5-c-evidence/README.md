# M5 自适应呈现证据

- `adaptive-settings-en.png`、`adaptive-settings-zh-Hans.png`：生产自适应设置视图、FloeForm/FloeSection 和 AnnotationView 的原生 NSHostingView 离屏渲染。640×720 逻辑点，强制展开 DisclosureGroup，使用内存偏好与生产本地化资源。只验证设置片段布局，不是完整 Floe 窗口或真实菜单栏操作截图。
- `display-spaces.json`：只读执行生产 `Bridging.fullscreenDisplayStates` 与持久屏幕身份代码，验证本机三台显示器的 UUID 映射，采样时均为非全屏。没有主动切换 Space，不能作为混合全屏或热插拔验收。

控制器、规则、菜单测量和 Space 字典解析使用 `script/tests/adaptive-*.swift` 与 `display-space-states.swift` 的受控环境回归。混合全屏、真实刘海和物理插拔的原场景验收仍保留，见 `../m5-c-status.json`。
