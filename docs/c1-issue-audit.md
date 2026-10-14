# M1 C1 核对与修复记录

日期：2026-10-14（Asia/Shanghai）。首批开始时工作区干净；第二批承接首批未提交改动。全部改动尚未提交或推送。

## 修复：事件 tap 失效后永久等待

`MenuBarItemManager.postEventAndWaitToReceive/scrombleEvent` 通过 continuation 等待事件，使用 `EventTap.enable(timeout:onTimeout:)` 的 50ms 截止时间结束失败操作。
原方法仅在 `isEnabled == true` 时触发超时：权限/资源导致 tap 创建失败，或系统禁用 tap 后没有再送来事件时，会跳过结束回调。调用者永久停留在 await；没有真实事件时无法靠 callback 恢复。

修复将“操作尚未完成”与“系统 tap 是否启用”分离，使用每次等待的 UUID。截止时间到达时，只要本次等待仍有效就调用失败回调，不再依赖系统启用状态。主动 `disable()` 清除本次等待；重新创建有界等待替换 UUID，旧截止时间不能结束新操作。系统回调使用普通 `enable()` 恢复 tap 时，保留原截止时间，不延长操作。

这是可确认的生产代码缺陷，关联 [jordanbaird/Ice#746](https://github.com/jordanbaird/Ice/issues/746) 的事件操作超时链路；该报告描述的是 macOS 26.1 Beta 拖动时报错，并没有证明上述永久等待路径是其全部根因。故标记部分修复，不归档原报告，也不通过延长 50ms 掩盖问题。

## 第二批：修饰键等待与浮栏请求生命周期

本批承接未提交工作区，保留首批事件 tap 修复。

### 修饰键等待可以取消和超时

原 `waitForNoModifiersPressed` 在 flags 非空时安装事件订阅，再等待不可取消的 continuation。超时任务组即便已选中超时错误，也必须等待该子任务结束；如果没有下一条 flagsChanged，整个等待仍无法返回。`waitWithTask` 又创建了顶层 Task，调用者取消不会自动传播。

现改为每 10ms 在 MainActor 读取系统修饰键状态并检查取消，不再等待事件来解除 continuation。统一等待包装使用取消处理器停止内部 Task，已有移动/鼠标等待也获得取消传播。保留无 timeout 时用户按键期间的等待语义；不凭空增加用户操作截止时间。

最后一个 `RunLoopLocalEventMonitor` 使用点已消失，删除未使用类型；修饰键等待不再在 modal tracking loop 中抽取并重投整个事件队列。

关联 [jordanbaird/Ice#746](https://github.com/jordanbaird/Ice/issues/746) 的移动前置等待链路；具体拖动失败和系统事件超时仍需继续定位。

### 同一分区旧显示请求不能覆盖新请求

原 `FloeBarPanel.show` 在两次缓存 await 后只比较 `currentSection`。同一分区 A 请求先等待，关闭并在屏幕 B 打开同一分区后，A 的迟到结果仍通过比较，重新发布旧屏幕内容。连续同分区请求也有相同风险；取消当前任务后原逻辑仍继续显示。

每次 show 使用独立 UUID；close 清除 UUID，异步返回后只发布当前 UUID 的结果。只有仍拥有当前 UUID 的取消任务才能关闭面板，旧任务不能关闭新面板。两个缓存阶段均结束后检查，关闭或换屏通知淘汰的请求不会重新打开面板。

关联 [jordanbaird/Ice#590](https://github.com/jordanbaird/Ice/issues/590) 的快速点击和 [jordanbaird/Ice#790](https://github.com/jordanbaird/Ice/issues/790) 的多屏 hover 链路：本批再次通过主机授权核对两条状态/正文，均未变化。这里确认的是显示重入缺陷，**不是确认重复 Dock 实例或系统无响应由该缺陷造成**，两条仅标记相关防护已实现。

## 第三批：窗口发现列表的崩溃边界

本批承接前两批未提交改动，重新核对 `jordanbaird/Ice#603` 与 `jordanbaird/Ice#807` 的实时状态，仍 open，更新时间未变化。

读取 #603 评论链接的 [原始崩溃报告](https://gist.githubusercontent.com/jamesqo/c451bb58832398e24796a99b6a22f8c0/raw/837ac5f893f19219e5299d8305e97441f1faf1cf/ice_crash_report.txt)，本地保存于 [603 栈](c1-evidence/jordanbaird-Ice-603-crash.txt)。主线程栈包含 Combine debounce，寄存器含 `windowNumber` 线索；当前安全窗口 ID 转换已继承，但缺少对应符号化，不能仅据此归档整个启动崩溃报告。

读取 #807 附件的 [原始日志](https://github.com/user-attachments/files/23944328/ice_logs.txt)，本地保存于 [807 日志](c1-evidence/jordanbaird-Ice-807-logs.txt)。末尾包含 `layoutSubtreeIfNeeded` 在布局过程中被调用的 AppKit 警告和 FrontBoard scene 更新；日志不是线程采样，没有足够证据把 XPC 或该警告确认为无响应根因，不以猜测替换系统布局行为。

进一步检查发现调用链时，确认 `Bridging` 的两个 count 查询即使失败也消费输出值，三个列表方法直接用输出数量创建数组/切片。负数量会在分配或范围创建时 trap；列表填充返回的 realCount 超出先前容量会在切片时 trap。窗口数量和列表不是同一时点快照，不能把返回 success 等同于数组边界有效。

修复行为：

- count 查询失败或负数量返回 0，不消费失败输出。
- 空容量不调用列表填充 API。
- 三个列表都检查 `0 <= realCount <= buffer.count`，异常返回空列表并记录日志，供既有发现恢复/fallback 处理；不拿部分截断输出冒充完整列表。
- 正常返回仍保留真实数量前缀，包括 realCount 为 0。

这是生产代码中可受控复现的 trap 路径，属于启动/点击时窗口发现的共享稳定性修复。**现有 C1 原始报告没有证明发生过上述异常数量；不把 #603/#807 或其他 C1 标记为确定修复。** 私有 API 内部越界写、永久阻塞和极端正数量的资源消耗不在本次边界检查保证范围内。

## 第四批：移动到位检查限频和取消

本批保留前三批未提交改动。通过主机 `gh` 重新核对 `jordanbaird/Ice#746`，仍 open，更新时间未变化。

`slowMove` 在完成移动后创建顶层超时 Task，持续查询 `itemHasCorrectPosition`，循环没有 sleep。目标一直未到位时，这条路径会在整个超时间隔反复执行坐标查询，给主线程与 WindowServer 施加额外压力；外部取消也不传播到内部 Task，`itemMoveCount` 直到内部超时才释放。`waitForFrameChange` 虽已有 1ms 限频，同样缺少外部取消传播。

两种等待都改为使用已验证的 `waitWithTask` 取消包装；到位失败时暂停 10ms 再查，不改变现有成功判断、超时值与错误映射。外部取消按 `CancellationError` 结束，到位等待的 defer 立即释放移动计数；frame 消失时原有固定延迟 fallback 保留。

这修复了生产移动链路的忙轮询与取消后后台检查继续运行；尚未确认是 `jordanbaird/Ice#746` 原报告“每次拖动都超时”的完整原因，不归档该报告。50ms frame 检查和 1s 到位检查仍遵循原配置。

## 第五批：#563 缺失分隔符时空数组崩溃（已修复归档）

通过主机授权复核 [jordanbaird/Ice#563](https://github.com/jordanbaird/Ice/issues/563)，仍 open，更新时间未变化。下载 0.11.12 官方发布产物，仅静态读取，不启动上游应用。

原报告 Ice image UUID 与发布产物 arm64 UUID **438423DB-718A-3FC0-9935-2A5721737382** 一致；崩溃偏移 **470828 / 0x72f2c**。反汇编显示 `trimPrefix` 后读取数组 count，count 为 0 时跳转到该地址的 `brk #1`。匹配标签源码在临时显示路径先移除隐藏分隔符之前的项目，再无条件 `removeFirst()`；未发现分隔符时 trimPrefix 会清空全部项目。当前 Floe 仍有该操作，根因可用缺失分隔符的发现快照复现。

新增生产边界方法先查找真实隐藏分隔符，缺失时返回 nil；调用者记录日志后安全结束临时显示，不移动、不点击、不创建恢复 context。存在分隔符时仍只使用其后项目；分隔符位于列表末尾时保留既有“没有显示空间”路径，不将之前的隐藏项选作目标。

[静态证据](c1-evidence/jordanbaird-Ice-563-static-audit.md) 保存 UUID、二进制哈希、源代码链接和相关指令片段。发布二进制已剥离符号，以上是匹配 UUID 的指令与源码交叉核对，**不称为 dSYM 符号化**。同一产物 0xC934 另外确认窗口 ID 溢出指令，与 #563 的数组根因不同；其他报告含多个症状，不在本次批量删除。

#563 的明确崩溃根因已修复、生产边界回归通过，按既有代码层归档口径移出本地待处理清单；原始完整报告继续保留在 C1 核对快照。不修改 GitHub 状态，未声称完成 macOS 26/27 全场景实机验收。当前待处理：C1 **28**、M1 **81**、总清单 **378**；累计本地归档 **24**。

## 第六批：7 条精确窗口 ID 溢出报告确认已继承修复

本批逐条重新读取原 issue 与全部评论，均仍 open；原文与评论已更新保存于 `c1-upstream-review.json`，不是仅按相似现象合并报告。

| 原报告 | 匹配 binary UUID | 崩溃偏移 | 原报告 x19 | 结论 |
| --- | --- | --- | --- | --- |
| [jordanbaird/Ice#669](https://github.com/jordanbaird/Ice/issues/669) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#779](https://github.com/jordanbaird/Ice/issues/779) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#810](https://github.com/jordanbaird/Ice/issues/810) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#821](https://github.com/jordanbaird/Ice/issues/821) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#867](https://github.com/jordanbaird/Ice/issues/867) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#880](https://github.com/jordanbaird/Ice/issues/880) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |
| [jordanbaird/Ice#947](https://github.com/jordanbaird/Ice/issues/947) | 438423DB-718A-3FC0-9935-2A5721737382 | 51508 / 0xC934 | 4294967296 | 已继承安全转换，代码层归档 |

以上七条**原报告正文**各自包含相同 binary UUID、崩溃偏移及溢出值，不依赖其他人的猜测评论。匹配官方发布二进制的指令先调用 windowNumber，把结果保存在 x19，右移 32 位后非零则在 0xC934 执行 brk，明确是 Int→UInt32 溢出。#669 使用文本 ARM 寄存器，其余使用 JSON threadState，均逐条提取与核验。

Floe 的 ControlItem getter 和浮栏 frame observer 已继承 failable 转换；本批扩展 `window-id.swift`，编译两个真实生产表达式，把七条报告的实际值逐条送入，均得到 nil 而不 trap，正常编号仍能查询。`floe-bar-position.swift` 确认 nil-ID 时沿用现有 frame 定位 fallback，不把防崩溃改成无法定位。

[静态核对](c1-evidence/window-id-static-audit.md) 和 [机器签名](c1-evidence/window-id-crash-signatures.json) 保存可复核证据。按 #925/#563 相同的代码层判定口径，将七条从本地待处理清单移出；这是确认继承修复覆盖原报告，**不是本批新写七个生产补丁**。未改变上游状态，未运行上游应用或宣称 macOS 26/27 全场景实机验收。其余 21 条包含未匹配的崩溃、额外功能症状和无响应，继续保留。

当前 C1 **21**、M1 **74**、总清单 **371**，累计本地归档 **31**。

## 第七批：#796/#905 附件确认，#777 线程采样核对

本批重新核对三条实时状态，均 open、更新时间未变化，并读取原始附件：

- [#796 原始附件](https://github.com/user-attachments/files/23753780/ICE.Crash.Report.txt)，本地 [崩溃报告](c1-evidence/jordanbaird-Ice-796-crash.txt)。
- [#905 原始附件](https://github.com/user-attachments/files/26292858/error.txt)，本地 [崩溃报告](c1-evidence/jordanbaird-Ice-905-crash.txt)。
- [#777 原始线程采样](https://github.com/user-attachments/files/23432457/Ice.sample.txt)，本地 [线程采样](c1-evidence/jordanbaird-Ice-777-sample.txt)。

#796/#905 两份附件的 Ice arm64 UUID 均为 438423DB-718A-3FC0-9935-2A5721737382，主线程首帧偏移均 51508/0xC934，x19 均 4294967296。匹配指令确认窗口 ID 溢出，Floe 已继承两个转换点的安全处理。签名纳入机器证据，生产回归逐条验证这两个实际值，nil-ID 定位回归通过。#905 正文“并发 race”的推断不由附件指令支持；采用原始寄存器和指令确定整数溢出，不照抄推断。

两条按同一代码层口径归档。没有新增生产补丁，未操作上游状态或宣称完成 macOS 26/27 实机验收。当前 C1 **19**、M1 **72**、总清单 **369**、累计归档 **33**。

#777 采样显示：主线程在 `OS_dispatch_queue.sync → __DISPATCH_WAIT_FOR_QUEUE__` 等截图队列；`ScreenCapture.captureQueue` 在 `SLWindowListCreateImageFromArray → SLSWindowListCreateImageFromArrayProxying → semaphore_timedwait_trap` 阻塞，多个后台调用也在等该队列。该证据直接支持前一批“移除调用者同步等待、有界超时、限制实际捕获并发”的修复方向，但无法确定系统截图永久阻塞的内部原因，也无法由当前实现证明后续截图功能可恢复；仍保留部分修复，不归档。

## 第八批：#603 dev.1 启动崩溃与 #742 浮栏崩溃

通过主机授权重新核对 #603/#742 当前状态，均 open、更新时间未变化。#603 的附件由 issue 作者 jamesqo 在 [原评论](https://github.com/jordanbaird/Ice/issues/603#issuecomment-3183362204) 提供，不引用其他人的相似报告替代作者证据。

#603 附件版本为 0.11.13-dev.1，下载对应官方产物静态读取，两者 arm64 UUID 都是 3781D582-B6AF-366C-B5A0-266BF26B7919。首帧偏移 744444/0xB5BFC；报告 x0=8589934592。指令调用 windowNumber 后将 x0 右移 32 位，非零直接跳到该 trap，明确是浮栏 frame observer 的 UInt32 溢出，和 0.11.12 的 ControlItem getter trap 地址不同。

#742 原文包含 0.11.12 UUID 438423DB-718A-3FC0-9935-2A5721737382、0xC934 首帧与 x19=4294967296，其步骤是启用浮栏后显示隐藏分区。报告的明确崩溃签名匹配已确认整数溢出，不只根据标题中的“浮栏不工作”作判断。

两个实际值加入机器签名，生产 getter 与浮栏 observer 表达式逐条回归得到 nil，正常 ID 仍保留，nil-ID 定位 fallback 通过。Floe 已继承这两个安全转换，无需重复新增生产补丁；按原报告明确根因归档 #603/#742。作者 dev.1 [静态核对](c1-evidence/jordanbaird-Ice-603-static-audit.md) 保存 UUID、哈希和指令，未启动上游应用或宣称 macOS 26/27 全场景验收。

当前 C1 **17**、M1 **70**、总清单 **367**、累计本地归档 **35**。

## 第九批：截图等待取消收尾（新增生产修复）

通过主机授权复核 #777，仍 open、更新时间未变化。本批保留前八批未提交改动。

现有执行器只在入口检查取消；进入 `withCheckedContinuation` 后，父任务取消不会恢复等待，调用者仍停留到完整截图截止时间。已用实际生产执行器和受控阻塞截图复现：4 秒截止任务被取消后，原实现直到超时才返回，未通过及时返回检查。

新增取消处理器结束本次 result，但不释放正在执行的系统截图占用标记。continuation 安装前发生取消时，result 记录完成状态，安装后返回 nil，避免漏掉取消。取消、超时与系统完成共享锁保护的单次恢复状态。队列实际开始前已完成的请求跳过系统 API，并由队列释放占用；已开始的同步调用仍须真实返回后才释放，取消与开始竞争时不能保证系统调用完全没有开始。

`screen-capture-executor.swift` 扩展生产回归：阻塞捕获取消后及时返回 nil、取消后新请求仍被拒绝、迟到真实完成后恢复、入口已取消不执行，以及 100 次注册/取消/完成/超时竞争。原执行器同一回归失败（`/tmp/Floe-C1-capture-before.log`），修复后通过。测试使用 semaphore 模拟系统阻塞，不截图、不申请权限。

这解决调用者取消后的悬挂等待，仍无法取消或修复 #777 的系统捕获永久阻塞；保持部分修复，不归档。当前 C1 **17**、M1 **70**、总清单 **367**，数量不变。

第九批 Debug/Release 构建、全部 17 个脚本、严格 SwiftLint 117 文件均通过。日志继续使用 `/tmp/Floe-C1-Debug.log`、`/tmp/Floe-C1-Release.log`、`/tmp/Floe-C1-regression.log`、`/tmp/Floe-C1-lint.log`。

## 第十批：临时显示项目的恢复重入与记录覆盖（新增生产修复）

本批继续检查 #746 相关移动/失败收尾链路；通过主机授权复核该条仍 open、更新时间未变化。保留前九批未提交改动。

`rehideTempShownItems` 会跨 await 移动项目，但没有防重入，重复计时器/调用可同时恢复同一共享列表。原循环直接从当前列表 popLast，await 期间新显示项目加入后也被同一轮立即消费；失败收尾用 `tempShownItemContexts = failedContexts`，会覆盖期间新增的恢复记录。成功收尾则不检查新增记录，直接清除计时器。

修复增加单轮恢复标记并在 defer 清除，进入后获取本轮记录快照，新的记录留在当前列表。失败时追加失败记录，不替换新增记录，仍按原 3 秒失败重试规则安排计时器；没有失败且当前列表也空时才清除计时器，成功恢复期间新增项目的计时器保留。移动计数和鼠标隐藏仍由 defer 成对收尾。缺失发现项和菜单正在使用时的原处理规则不改变。

新增 `temp-rehide-lifecycle.swift` 编译完整生产恢复方法：模拟移动期间重入、新项目加入、旧项目失败，验证不重叠、两类记录都保留；成功路径验证新计时器不被清除；鼠标按下时保留原延迟重试，所有路径计数/恢复标记/鼠标隐藏平衡。原方法同一受控回归允许第二次恢复进入，在单轮测试夹具中触发 watchdog（`/tmp/Floe-C1-rehide-before.log`）；这证明缺少重入隔离，不把夹具等待描述为原应用一定永久卡死。

这是共享恢复状态的明确代码缺陷，不证明 #746 的全部拖动超时或其他 C1 无响应由它引起。保持部分修复，待处理数量仍为 C1 **17**、M1 **70**、总清单 **367**。

## 第十一批：空发现快照保留临时恢复记录（新增生产修复）

本批继续核对移动与恢复交叉流程；#746 实时仍 open、更新时间未变化。保留此前未提交改动。

第十批已隔离恢复重入，但原流程在发现前清空恢复记录；WindowServer/权限/分区切换暂时返回空列表时，每条 context 因找不到 item 被跳过，最终记录全部消失且计时器被清除。一次空快照会使之后的发现恢复也没有任何记录可恢复。

现先发现项目，整份列表为空时保留全部原记录并按已有 3 秒规则重试，不隐藏鼠标、不启动移动；发现有效后再提取本轮快照。已有菜单保护、单轮隔离、正常成功与失败处理保持原规则。部分发现列表中单个已消失项目仍按原规则处理，不凭空认定所有缺失项目都可重建。

扩展 `temp-rehide-lifecycle.swift` 的完整生产方法回归：连续 20 次空发现不丢记录、不移动、计数/恢复标记/鼠标隐藏平衡；随后发现恢复，一次完成实际模拟移动并清理记录。去掉本批空发现分支、保持第十批其他改动的前一实现未通过此回归，修复后通过（对照日志 `/tmp/Floe-C1-empty-before.log`）。

这是已确认的恢复记录丢失路径，仍未证明 #746 原始“每次拖动都超时”由该路径引起，不归档具体报告。当前 C1 **17**、M1 **70**、总清单 **367** 不变。

## 全部 C1 实时核对

使用主机已有 `gh` 授权读取全部 29 条 issue 与评论；均为 open。完整原文与评论存于 [核对快照](c1-upstream-review.json)。前四批保留 C1 **29**，M1 **82**，总清单 **379**；第五批归档 #563 后为 C1 **28**，M1 **81**，总清单 **378**；第六批 7 条归档后 C1 **21**，M1 **74**，总清单 **371**；第七批 C1 **19**，M1 **72**，总清单 **369**；第八批当前 C1 **17**，M1 **70**，总清单 **367**。

`jordanbaird/Ice#647` 评论明确报告整数转换位数不足；当前 Floe 安全窗口 ID 转换已继承，生产 getter 回归覆盖溢出，但没有足够证据将正文所有症状归档。其他未经符号化的 SIGTRAP、正文症状或评论中的“可能相关”不足以确认同一根因。

| Issue | 实时状态 | 评论数 | 处理状态 |
| --- | --- | --- | --- |
| [jordanbaird/Ice#563](https://github.com/jordanbaird/Ice/issues/563) | open | 2 | 已修复归档 · 匹配 UUID 的空数组 removeFirst trap |
| [jordanbaird/Ice#590](https://github.com/jordanbaird/Ice/issues/590) | open | 2 | 相关防护已实现 · 快速切换显示请求隔离；Dock 症状待定位 |
| [jordanbaird/Ice#603](https://github.com/jordanbaird/Ice/issues/603) | open | 9 | 已继承修复归档 · 匹配版本 UUID/溢出指令/寄存器值 |
| [jordanbaird/Ice#635](https://github.com/jordanbaird/Ice/issues/635) | open | 5 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#647](https://github.com/jordanbaird/Ice/issues/647) | open | 26 | 相关防护已继承 · 评论确认整数溢出；完整报告待验证 |
| [jordanbaird/Ice#665](https://github.com/jordanbaird/Ice/issues/665) | open | 20 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#669](https://github.com/jordanbaird/Ice/issues/669) | open | 5 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#671](https://github.com/jordanbaird/Ice/issues/671) | open | 4 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#721](https://github.com/jordanbaird/Ice/issues/721) | open | 11 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#740](https://github.com/jordanbaird/Ice/issues/740) | open | 3 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#742](https://github.com/jordanbaird/Ice/issues/742) | open | 9 | 已继承修复归档 · 匹配版本 UUID/溢出指令/寄存器值 |
| [jordanbaird/Ice#746](https://github.com/jordanbaird/Ice/issues/746) | open | 0 | 部分修复 · tap/输入/移动等待修复；拖动失败根因待复测 |
| [jordanbaird/Ice#777](https://github.com/jordanbaird/Ice/issues/777) | open | 0 | 部分修复 · 后台截图/超时/取消收尾；系统 API 阻塞待复测 |
| [jordanbaird/Ice#779](https://github.com/jordanbaird/Ice/issues/779) | open | 2 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#786](https://github.com/jordanbaird/Ice/issues/786) | open | 20 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#790](https://github.com/jordanbaird/Ice/issues/790) | open | 1 | 相关防护已实现 · 同分区跨屏旧请求淘汰；冻结因果待定位 |
| [jordanbaird/Ice#796](https://github.com/jordanbaird/Ice/issues/796) | open | 2 | 已继承修复归档 · 原始附件 UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#807](https://github.com/jordanbaird/Ice/issues/807) | open | 3 | 调查中 · 已读布局递归日志；无响应线程待定位 |
| [jordanbaird/Ice#810](https://github.com/jordanbaird/Ice/issues/810) | open | 5 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#821](https://github.com/jordanbaird/Ice/issues/821) | open | 12 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#838](https://github.com/jordanbaird/Ice/issues/838) | open | 1 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#840](https://github.com/jordanbaird/Ice/issues/840) | open | 8 | 相关防护已继承 · 安全窗口 ID 转换；完整报告待验证 |
| [jordanbaird/Ice#855](https://github.com/jordanbaird/Ice/issues/855) | open | 2 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#867](https://github.com/jordanbaird/Ice/issues/867) | open | 15 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#877](https://github.com/jordanbaird/Ice/issues/877) | open | 11 | 已核对 · 未建立可验证的独立根因，继续保留 |
| [jordanbaird/Ice#880](https://github.com/jordanbaird/Ice/issues/880) | open | 0 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#905](https://github.com/jordanbaird/Ice/issues/905) | open | 2 | 已继承修复归档 · 原始附件 UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#947](https://github.com/jordanbaird/Ice/issues/947) | open | 16 | 已继承修复归档 · UUID/0xC934/x19 精确匹配 |
| [jordanbaird/Ice#977](https://github.com/jordanbaird/Ice/issues/977) | open | 3 | 已核对 · 点击崩溃栈未符号化；保留报告验收 |

## 验证与边界

第十一批 Debug/Release、全部 18 个回归脚本和严格 SwiftLint 117 文件均通过；新增空快照/恢复场景与之前的重入/失败收尾场景均通过。


第十批新增生产恢复隔离及完整方法回归；Debug/Release、全部 18 个回归脚本与严格 SwiftLint 117 文件均通过。


第八批生产转换回归包含 #603 的 8589934592 与 #742 的 4294967296；两个转换点及 nil-ID 定位通过。无新生产改动，不重复执行无关构建。


第七批重新运行生产 window-ID 两个转换点与浮栏定位回归，均通过；没有新增生产改动，不重复宣称执行全量构建。


第六批仅调整证据、归档索引与回归脚本，没有新改生产行为；重新运行扩展后的 `window-id.swift` 与既有 `floe-bar-position.swift`，均通过。此前 Debug/Release、17 个脚本与严格 SwiftLint 的结果保留，不将其表述为本批重复执行全部构建。各索引计数与保留原文逐字对照通过；原文清单中的历史尾空白保留，Git diff 对删除后重新对齐的 4 条原文行报告尾空白，其余文件的 `git diff --check` 通过。


- 新增 `temp-show-boundary.swift`：编译生产边界方法，验证空发现、仅普通项、分隔符唯一/末尾/中间，以及 0–200 个项目组合，缺失时返回 nil，存在时保持后续项的顺序和身份。

- 新增 `move-wait-cancellation.swift`：编译生产 slowMove、frame 检查、统一等待与 TaskTimeout。验证 100ms 未到位时查询不超过 25 次（留调度余量），超时错误映射、取消后计数释放且不再查询、正常到位、frame 等待取消及正常变化。测试不移动真实鼠标/状态项。同一回归编译 HEAD 原生产方法时在查询次数上限检查失败，修复后通过；对照日志 `/tmp/Floe-C1-move-before.log`。

- 新增 `window-list-bounds.swift`：编译生产两个 count/三个 list 方法，覆盖 count 失败但输出为正、负数/Int32.min/零、列表失败、realCount 为负/超容量/Int32.max，以及合法空/短/完整前缀。同一回归使用 HEAD 原生产方法会触发 Fatal error，修复后通过；对照日志 `/tmp/Floe-C1-window-list-before.log`。

- 新增 `input-wait-cancellation.swift`：编译生产统一等待、修饰键/鼠标/移动等待及 `TaskTimeout.swift`，验证持续按键超时、父任务取消、无事件的按键释放、移动等待取消、调用前已取消。
- 新增 `floe-bar-lifecycle.swift`：编译生产 show/close，控制缓存完成顺序，验证同分区关闭再打开时旧屏幕迟到、关闭期间刷新、取消当前请求，以及图片缓存阶段关闭后不再打开。

- `script/tests/event-tap-timeout.swift` 编译生产超时和禁用方法，以可控 tap 测试创建失败、系统禁用、成功完成、旧超时隔离、重复有界启用、系统重新启用不延长截止时间，以及超时只触发一次。
- 测试不创建真实 tap，不修改菜单栏或 TCC。未完成 macOS 26/27 报告场景实测；其余未定位条目继续保留，不用本次修复替代符号化或最小复现。
- macOS 15.8.1 / Xcode 26.3：Debug、Release 构建通过；全部 17 个回归脚本通过；SwiftLint 0.65.1 严格检查 117 个文件，0 violations；`git diff --check` 通过。
- 截止任务在 MainActor 调度，不能中断被同步系统调用卡住的主线程，也不承诺恰好 50ms 的墙钟返回；本修复消除的是以 `isEnabled` 跳过结束回调的逻辑缺陷。
- 日志：`/tmp/Floe-C1-Debug.log`、`/tmp/Floe-C1-Release.log`、`/tmp/Floe-C1-regression.log`、`/tmp/Floe-C1-lint.log`，临时文件可能被清理。
