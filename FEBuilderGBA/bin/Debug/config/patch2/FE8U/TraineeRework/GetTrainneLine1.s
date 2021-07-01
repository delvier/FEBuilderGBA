@ORG D24F0	@{J}
@ORG CD800	@{U}

.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@r0  this procs
@r5  table

push {r0}
ldrh r4, [r0, #0x2a]  @thisProcs->UnitID

ldr  r5, Table
sub  r5, #0x10

Loop:
add  r5, #0x10

ldr  r0, [r5,#0x0] @�I�[�`�F�b�N
cmp  r0, #0xff
beq  NotFound

CheckUnit:
ldrb r0, [r5,#0x0] @Table->UnitID
cmp  r0, r4
bne  Loop

@blh 0x08017fb0   @GetUnitByCharId	@{J}
blh 0x0801829c   @GetUnitByCharId	@{U}
cmp  r0, #0x0  @�O�̂���null�m�F
beq  Loop

CheckClass:
ldr  r1, [r0,#0x04] 
ldrb r1, [r1,#0x04] @Unit->Class->ID
ldrb r2, [r5,#0x2]  @Table->ClassID
cmp  r1, r2
bne  Loop

CheckLV:
ldrb r1, [r0,#0x08] @Unit->LV
ldrb r2, [r5,#0x1]  @Table->LV
cmp  r1, r2
blt  Loop

CheckFlag:
ldrh r0,[r5, #0x4]  @CheckFlag
cmp  r0,#0x0
beq  CheckText

@blh  0x080860d0	@CheckFlag	@{J}
blh  0x08083DA8	@CheckFlag	@{U}
cmp  r0, #0x0
beq  Loop

CheckText:
ldrh r0, [r5,#0x6]  @Table->Text1
cmp  r0, #0x0
beq  Loop

Found:
pop {r0}

add r0, #0x2e
ldrb r0, [r0, #0x0]

mov r4, #0x0
str r4, [sp, #0x0]
mov r1, #0xd4
mov r2, #0x50
mov r3, #0x82
@blh 0x0800783c,r4   @��O���t�B�b�N�̃��[�h r0=��ID r1=? r2=? r3=?	@{J}
blh 0x08007938,r4   @��O���t�B�b�N�̃��[�h r0=��ID r1=? r2=? r3=?	@{U}

mov  r4, #0x0
ldrh r0, [r5,#0x6]  @Table->Text1
@ldr r3,=0x080D2536|1	@{J}
ldr r3,=0x080CD846|1	@{U}
bx r3

NotFound:
pop {r0}
mov r1, #0x3
@blh 0x08002e74   @Goto6CLabel	@{J}
blh 0x08002f24   @Goto6CLabel	@{U}

Exit:
@ldr r3, =0x080D2572|1	@{J}
ldr r3, =0x080CD882|1	@{U}
bx  r3

.align
.ltorg
Table:
@Table