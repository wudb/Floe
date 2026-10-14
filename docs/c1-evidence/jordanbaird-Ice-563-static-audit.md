# jordanbaird/Ice#563 static crash audit

Reviewed: 2026-10-14 (Asia/Shanghai)
Release: https://github.com/jordanbaird/Ice/releases/tag/0.11.12
Binary arm64 UUID: 438423DB-718A-3FC0-9935-2A5721737382
The issue crash report has the same Ice image UUID.
Binary SHA256 (universal executable): 4180a56a19e04d84184014a9e75fd42a995a1a3fc690232c54d115f9ea0daad6

Crash offset: 470828 (0x72f2c). Preferred address: 0x100072f2c.
Static decoding: trimPrefix call, load array count, cbz to brk when count is zero.
The binary is stripped; this is instruction and source cross-checking, not a dSYM symbolication.

Source: https://github.com/jordanbaird/Ice/blob/0.11.12/Ice/MenuBar/ItemManagement/MenuBarItemManager.swift
```swift
        // Remove all items up to the hidden control item.
        items.trimPrefix { $0.info != .hiddenControlItem }
        // Remove the hidden control item.
        items.removeFirst()
```

Instruction excerpts:
```
1000727e8:	00 00 00 b0	adrp	x0, 1 ; 0x100073000
1000727ec:	00 e0 05 91	add	x0, x0, #0x178
1000727f0:	74 e2 04 91	add	x20, x19, #0x138
1000727f4:	01 00 80 d2	mov	x1, #0x0
1000727f8:	e2 03 17 aa	mov	x2, x23
1000727fc:	e3 03 19 aa	mov	x3, x25
100072800:	38 4c 03 94	bl	0x1001458e0 ; symbol stub for: _$sSm17_StringProcessingE10trimPrefix5whileySb7ElementQzKXE_tKF
100072804:	7a 9e 40 f9	ldr	x26, [x19, #0x138]
100072808:	54 0b 40 f9	ldr	x20, [x26, #0x10]
10007280c:	14 39 00 b4	cbz	x20, 0x100072f2c
100072810:	e0 03 1a aa	mov	x0, x26
100072814:	e6 50 03 94	bl	0x100146bac ; symbol stub for: _swift_isUniquelyReferenced_nonNull_native
100072f2c:	20 00 20 d4	brk	#0x1
```

Additional 0xC934 signature: windowNumber is shifted right by 32, nonzero high bits branch to brk. This is kept separate from #563.
