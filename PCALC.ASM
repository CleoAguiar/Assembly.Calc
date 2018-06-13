	.CR 8085
	.TF CALC.hex,INT
	.LF CALC.lst

LETECLA .EQ 02E7H ; 
MOSTRAD .EQ 0363H ;
MOSTRAA .EQ 036EH ;

	.OR 2000H

	LXI SP,2200H 	; Inicializa pilha

LOOP:	CALL NUMERO
	MOV D,A
	MVI E,0H
	PUSH D
	CALL MOSTRAD	; Apresenta primeiro numero
	MVI A,00H
	CALL MOSTRAA	; Zera display
	POP D
	CALL NUMERO	; Le segundo numero
	MOV E,A
	PUSH D
	CALL MOSTRAD	; Apresenta os dois números
	POP D

LOOPOP:	CALL LETECLA
	CPI 0AH
	JZ CONTS	; Soma
	CPI 0BH
	JZ CONTM	; Subtracao
	CPI 0CH
	JZ CONTX	; Multiplicacao
	CPI 0DH
	JZ CONTD	; Divisao
	JMP LOOPOP

CONTS:	CALL MAIS	; Realiza operação de soma
	JMP CALC	; Exibe o resultado
	
CONTM:	MVI A,00H
	ADD D
	CMP E
	JC ERRO		; Verifica se n1 < n2

	MOV B,D
	CALL MENOS	; Realiza operação de subtracao
	JMP CALC	; Exibe o resultado

CONTX:	MVI A,00H
	ADD D
	CPI 00H
	JZ ZERO		; Verifica se n1 = 0
	MVI A,00H
	ADD E
	CPI 00H
	JZ ZERO		; verifica se n2 = 0

	CALL MULT	; Realiza operação de multiplicacao
	JMP CALC	; Exibe o resultado

CONTD:	MVI A,00H
	ADD D
	CPI 00H
	JZ ZERO		; verifica se n1 = 0 resultado 0	
	MVI A,00H
	ADD E
	CPI 00H
	JZ ERRO		; verificar se n2 = 0 erro na operacao
	CPI 01H
	JZ DIV1
	
	CALL DIV	; Realiza operação de divisao
	JMP CALC	; Exibe o resultado

ERRO:	MVI A,00H
	MVI B,01H
	SUB B
	JMP CALC	; Exibe o resultado erro FF

ZERO:	MVI A,00H
	JMP CALC	; Exibe o resultado 0

DIV1:	MVI A,00H
	ADD D
	JMP CALC

CALC:	CALL MOSTRAA 	; Apresenta resultado
	JMP LOOP
	.ED

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NUMERO: 
LOOPL:	CALL LETECLA 	; Le o numero
	CPI 0AH
	JP LOOPL 	; Volta se for >9
	RET

MENOS:	MVI A,00H	; inicialização
	ADD D		
	SUB E		
	RET

MAIS:	MVI A,00H 	; inicialização
	ADD D 		
	ADD E 		
	DAA 		; Soma BCD corrigida
	RET		; retorna com o número em A

MULT:	MOV C,E		; variavel de decremento
	MVI A,00H 	; inicialização
	
LOOPM:	ADD D 		; Soma N1 ao acumulador
	DAA 		; Soma BCD corrigida
	DCR C 		; decrementa o conteúdo de C
	JNZ LOOPM	; Desvia de C = 0
	RET		; retorna com o número em A

DIV:	MVI H,00H	; inicialização
	MVI A,00H
	ADD D		
LOOPD:	CMP E		; Compara N1 com o N2
	JC CONTDI	; Desvia se N1 < N2
	SUB E		; Subtrai acumulador
	INR H		; Incrementa resultado
	JMP LOOPD	
CONTDI:	MVI A,00H	; inicialização
	ADD H		; Adiciona resultado ao acumulador
	RET
