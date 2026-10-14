# Window ID overflow signature audit

Review: 2026-10-14 (Asia/Shanghai). Release binary was inspected statically, never launched.
arm64 UUID: `438423DB-718A-3FC0-9935-2A5721737382`.

Eight original issue bodies and two attached crash reports have the matching Ice UUID, crash offset 51508 (`0xC934`), and x19 = 4294967296. See [machine-readable signatures](window-id-crash-signatures.json) and full original bodies/comments in [review snapshot](../c1-upstream-review.json).

Instructions call `windowNumber`, retain the result in x19, shift by 32 and trap if the high word is nonzero. These reports identify the UInt32 overflow, independently of #563's empty-array trap. This is instruction/source verification from a stripped binary, not dSYM symbolication.

```asm
10000c90c:	e8 0c 00 b0	adrp	x8, 413 ; 0x1001a9000
10000c910:	01 a9 40 f9	ldr	x1, [x8, #0x150] ; Objc selector ref: windowNumber
10000c914:	e0 03 14 aa	mov	x0, x20
10000c918:	be e7 04 94	bl	0x100146810 ; Objc message: -[x0 windowNumber]
10000c91c:	f3 03 00 aa	mov	x19, x0
10000c920:	e0 03 14 aa	mov	x0, x20
10000c924:	c4 e7 04 94	bl	0x100146834 ; symbol stub for: _objc_release
10000c928:	b3 01 f8 b7	tbnz	x19, #0x3f, 0x10000c95c
10000c92c:	68 fe 60 d3	lsr	x8, x19, #32
10000c930:	88 00 00 b4	cbz	x8, 0x10000c940
10000c934:	20 00 20 d4	brk	#0x1
10000c938:	13 00 80 d2	mov	x19, #0x0
10000c93c:	28 00 80 52	mov	w8, #0x1
10000c940:	e8 33 00 39	strb	w8, [sp, #0xc]
10000c944:	08 1d 00 12	and	w8, w8, #0xff
10000c948:	60 82 08 aa	orr	x0, x19, x8, lsl #32
10000c94c:	fd 7b 42 a9	ldp	x29, x30, [sp, #0x20]
10000c950:	f4 4f 41 a9	ldp	x20, x19, [sp, #0x10]
10000c954:	ff c3 00 91	add	sp, sp, #0x30
10000c958:	c0 03 5f d6	ret
10000c95c:	20 00 20 d4	brk	#0x1
```

Floe already uses `CGWindowID(exactly:)` in both the ControlItem getter and the panel frame observer. Production regression compiles both expressions and passes the exact report value through each. The bar positioning regression covers nil-ID fallback. Local code-level archival does not alter upstream status or claim macOS 26/27 whole-system acceptance.

The additional dev.1 startup report uses a different binary UUID and trap address: see [603 static audit](jordanbaird-Ice-603-static-audit.md). Its x0 value is 8589934592; the same production safe conversions reject it.
