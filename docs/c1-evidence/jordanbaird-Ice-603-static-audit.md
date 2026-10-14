# jordanbaird/Ice#603 startup crash audit

Source report was provided by the issue author jamesqo in [this comment](https://github.com/jordanbaird/Ice/issues/603#issuecomment-3183362204). Both report and official 0.11.13-dev.1 binary match arm64 UUID 3781D582-B6AF-366C-B5A0-266BF26B7919. Crash offset 744444 = 0xB5BFC; report x0 = 8589934592 (0x200000000).

Binary SHA256: 10762f9f3e8d17cf7950e3f5732145522ca095b945472f250355b89569fe0a16

Static instructions call windowNumber, reject sign bit, shift result x0 by 32 and branch on nonzero high word to the exact trap address. Main stack contains Combine debounce, matching the panel frame observer. Floe already uses a failable conversion in that observer; the production expression regression includes this exact x0 value and nil-ID positioning fallback. Stripped binary instruction verification, not dSYM symbolication; upstream app never launched.

```asm
1000b5ac0:	f4 03 00 aa	mov	x20, x0
1000b5ac4:	e8 06 00 f0	adrp	x8, 223 ; 0x100194000
1000b5ac8:	01 c5 43 f9	ldr	x1, [x8, #0x788] ; Objc selector ref: windowNumber
1000b5acc:	1a ed 01 94	bl	0x100130f34 ; Objc message: -[x0 windowNumber]
1000b5ad0:	40 09 f8 b7	tbnz	x0, #0x3f, 0x1000b5bf8
1000b5ad4:	08 fc 60 d3	lsr	x8, x0, #32
1000b5ad8:	28 09 00 b5	cbnz	x8, 0x1000b5bfc
1000b5adc:	e8 03 13 aa	mov	x8, x19
1000b5bfc:	20 00 20 d4	brk	#0x1
```
