; Proyecto de Arquitectura de las Computadoras
; Alumno Alejandro Sánchez González
; Ejercicio #11 ordenar listas de numeros enteros con Merge Sort

data segment
    menu db "Seleccione la opcion deseada:",10,13,"1-Ingresar Lista",10,13,"2-Ordenar Lista",10,13,"3-Mostrar lista ordenada",10,13,"4-Salir",10,13,'$'
    op1 db "Ingrese la Lista deseada separando los numeros por coma(sin espacios), y terminando la cadena con un punto:",10,13, "$"
    op2 db "La lista ha sido ordenada con exito",10,13, "$"
    op3 db "Esta es la Lista ordenada",10,13, "$"
    op4 db "Hasta la proxima",10,13, "$"
    space db 10,13,'$'

    arr db 2000 DUP('.')
    arr_temp db 2000 DUP('.')

    cnt_num db ?
    cnt_num_middle db ?
    mitad db ?

    max db ?
    max_temp db ?

    puntero db ?
    searchPuntero db ?

    l db ?
    c db ?
    ci db ?
    cpoint db ?
    cpuntero db ?
    o db ?
    oi db ?
    opoint db ?
    opuntero db ?
    cnt db ?

    num1_lenght db ?
    num1_negative db ?
    num2_lenght db ?
    num2_negative db ?



    num db ?
ends

code segment
start:

    mov ax,data
    mov ds,ax
    MainMenu:
    mov ah,09h
    lea dx,menu
    int 21h;imprime el valor

    mov ah,01h
    int 21h
    sub al,30h
    mov num, al;coge el valor1

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h

    mov dl,num
    add dl,30h
    
    cmp num, 1
        jz opcion1

    cmp num, 2
        jz opcion2

    cmp num, 3
        jz opcion3

    cmp num, 4
        jz opcion4

    jmp MainMenu
ends 

opcion1:
    mov ah,09h
    lea dx, op1 ;genera un texto
    int 21h

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h

    mov max,0
    mov max_temp,0
    mov puntero, 0
    lea di, arr

    while:
        
        mov ah, 01h
        int 21h
        cmp al,'.'
            jz exitCapturas
        
        sub al, 30h
        mov [di], al

        inc max
        inc di
        jmp while
    ends

    exitCapturas:
        sub al,30h
        mov [di], al

        inc max

        mov ah,09h
        lea dx, space ;genera un espacio
        int 21h
        

        lea si, arr
        mov cnt_num,0
        mov puntero,0 
        mov ah, max
    leerCantidad: ; lee la cantidad de numeros entrados
        mov al, [si]
        add al, 30h
        cmp al, ','
            jz sum
        cmp al, '.'
            jz salir

        inc si
        inc puntero
        cmp puntero,ah
            jc leerCantidad

        sum:
            inc cnt_num
        
        inc si
        inc puntero
        cmp puntero,ah
            jc leerCantidad
    
    salir:
        inc cnt_num
    jmp MainMenu
ends

opcion2: ; inicializa variables de merge Sort

    mov puntero, 0
    mov ch,1
    mov l,1
    mov ci,0
    mov oi,0
    mov cpoint,0
    mov opoint,0
    mov c,0
    mov o,ch

    mov al, cnt_num
    shr al, 1
    mov cnt_num_middle, al
    mov mitad, al

    mov bl, mitad
    cmp mitad, 0
        jnp isImpar
    cmp mitad, 1
        jnp isImpar
    jmp mergeSort
    isImpar:
    inc mitad

    
    jmp mergeSort
    jmp introducirNum

    jmp MainMenu
ends

mergeSort:;busca los punteros para comparar
    lea si, arr
    lea di, arr

    cmp ch, cnt_num
        jg salirBucle
        je salirBucle

    mov al, l
    cmp al, mitad
        jg highL

        
    mov cpoint,0
    mov cpuntero,0
    mov al, c
    add al, ci
    mov cnt, 0


    avanzarC:
        mov bh,[si]
        cmp bh,'.'
            je AumC
        add bh,30h
        cmp bh,'.'
            je AumC
        cmp bh,','
            je AumC

        inc si
        inc cnt
        cmp cpoint,al
            jl avanzarC
            jg terminarC
            je terminarC
    AumC:
        inc cpoint
        inc cnt
        mov ah,cnt
        mov cpuntero,ah
        inc si

        cmp cpoint,al
            jl avanzarC
            jg terminarC
            je terminarC

    terminarC:
    
    cmp ci, ch
        jg leftEmpty
        je leftEmpty

    mov opoint, 0
    mov opuntero,0
    mov al, o
    add al, oi
    mov cnt,0

    cmp al, cnt_num
        jg rightEmpty
        je rightEmpty

    lea si, arr
    avanzarO:
        mov bh,[si]
        cmp bh,'.'
            je AumO
        add bh,30h
        cmp bh,'.'
            je AumO

        cmp bh,','
            je AumO

        inc si
        inc cnt
        cmp opoint,al
            jl avanzarO
            jg terminarO
            je terminarO
    AumO:
        inc opoint
        inc cnt
        mov ah,cnt
        mov opuntero,ah
        inc si

        cmp opoint,al
            jl avanzarO
            jg terminarO
            je terminarO

    terminarO:

    cmp oi, ch
        jg rightEmpty
        je rightEmpty


    jmp compararLenght

ends
salirBucle:; termina el merge sort
    mov ah,09h
    lea dx, op2 ;genera un texto
    int 21h

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h
    jmp rewriteArr
ends
compararLenght:;compara el tamaño de los numeros q se comprobaran
    lea si,arr
    mov num1_lenght, 0
    mov num1_negative,0
    
    mov searchPuntero,0 
    mov ah, cpuntero

    cmp searchPuntero,ah
        jl irPosicionArrComp
        je ContarDigitos
    irPosicionArrComp:
        inc si
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrComp
    
    ContarDigitos:
        mov bh, [si]
        add bh, 30h

        cmp bh, '-'
            je Num1IsNegative
        cmp bh, ','
            je ContinueComp
        cmp bh, '.'
            je ContinueComp

        inc num1_lenght
        inc si
        jmp ContarDigitos
    Num1IsNegative:
        mov num1_negative,1
        inc si
        jmp ContarDigitos

    ContinueComp:

    lea si,arr
    mov num2_lenght, 0
    mov num2_negative, 0
    
    mov searchPuntero,0 
    mov ah, opuntero

    cmp searchPuntero,ah
        jl irPosicionArrComp2
        je ContarDigitos2
    irPosicionArrComp2:
        inc si
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrComp2
    
    ContarDigitos2:
        mov bh, [si]
        cmp bh, '.'
            je ContinueComp2

        add bh, 30h

        cmp bh, '-'
            je Num2IsNegative
        cmp bh, ','
            je ContinueComp2
        cmp bh, '.'
            je ContinueComp2

        inc num2_lenght
        inc si
        jmp ContarDigitos2
    Num2IsNegative:
        mov num2_negative,1
        inc si
        jmp ContarDigitos2

    ContinueComp2:
        mov ah,num1_negative

        cmp ah,num2_negative
            jl introducir_der
            jg introducir_izq
        
        cmp ah,1
            je compararConNegativo
            jl compararSinNegativo
ends
compararSinNegativo:; la comparacion para numeros q no son negativos
    mov ah, num1_lenght

    cmp ah,num2_lenght
        jl introducir_izq
        jg introducir_der

    lea si,arr
    lea di, arr

    mov searchPuntero,0 
    mov ah, cpuntero

    cmp searchPuntero,ah
        jl irPosicionArrCMPNum1
        je continueCMPNum1
    irPosicionArrCMPNum1:
        inc si
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrCMPNum1
    
    continueCMPNum1:
    mov searchPuntero, 0
    mov ah, opuntero
    
    cmp searchPuntero, ah
        jl irPosicionArrTempCMPNum2
        je StartComparing
    irPosicionArrTempCMPNum2:
        inc di
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrTempCMPNum2

    StartComparing:
        mov ah,[di]
        cmp [si],ah
            jl introducir_izq
            jg introducir_der
        cmp [si],','
            je introducir_izq
        
        inc di
        inc si
        jmp StartComparing
    
    jmp MainMenu
ends
compararConNegativo: ;comparacion para numeros negativos
    mov ah, num1_lenght

    cmp ah,num2_lenght
        jg introducir_izq
        jl introducir_der

    lea si,arr
    lea di, arr

    mov searchPuntero,0 
    mov ah, cpuntero

    cmp searchPuntero,ah
        jl irPosicionArrCMPNegativeNum1
        je continueCMPNegativeNum1
    irPosicionArrCMPNegativeNum1:
        inc si
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrCMPNegativeNum1
    
    continueCMPNegativeNum1:
    mov searchPuntero, 0
    mov ah, opuntero
    
    cmp searchPuntero, ah
        jl irPosicionArrTempCMPNegativeNum2
        je StartComparingNegative
    irPosicionArrTempCMPNegativeNum2:
        inc di
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrTempCMPNegativeNum2

    StartComparingNegative:
        mov ah,[di]
        cmp [si],ah
            jg introducir_izq
            jl introducir_der
        cmp [si],','
            je introducir_izq
        
        inc di
        inc si
        jmp StartComparingNegative
    
    jmp MainMenu
ends

highL:;una vez q l llega a su tope
    mov ah, ch
    add ch,ah
    mov l,1
    mov ci,0
    mov oi,0
    mov c,0
    mov o, ch
    mov max_temp, 0

    mov al, mitad
    shr al, 1
    mov mitad, al
    

    cmp mitad, 0
        je Ajustar
        jg rewriteArrHighL
    
    Ajustar:
        mov mitad,1
ends
rewriteArrHighL:;reescribe el arreglo resultante
    lea si, arr_temp
    lea di, arr
    
    mov puntero,0
    mov ah, max

    whileRewriteHighL:
        mov al, [si]
        mov [di],al
        inc di
        inc si
        inc puntero
        cmp puntero, ah
            jl whileRewriteHighL
    jmp mergeSort
ends
leftEmpty:;cuando el puntero de la izq se queda sin numeros
    cmp oi, ch
        jg bothEmpty
        je bothEmpty

    mov al, o
    add al, oi
    cmp al, cnt_num
        jg bothEmpty
        je bothEmpty


    lea si, arr

    mov opoint, 0
    mov opuntero,0
    mov al, o
    add al, oi
    mov cnt,0

    
    lea si, arr
    avanzarO1:
        mov bh,[si]

        cmp bh, '.'
            je salirBucleIntroducir

        add bh,30h
        cmp bh,'.'
            je AumO1

        cmp bh,','
            je AumO1

        inc si
        inc cnt
        cmp opoint,al
            jl avanzarO1
            jg terminarO1
            je terminarO1
    AumO1:
        inc opoint
        inc cnt
        mov ah,cnt
        mov opuntero,ah
        inc si

        cmp opoint,al
            jl avanzarO1

    terminarO1:

    jmp introducir_der
ends
rightEmpty:;cuando el de la derecha se queda sin numeros
    jmp introducir_izq
ends
bothEmpty:;cuando ambos se quedan sin numeros
    inc l
    mov ci,0
    mov oi,0
    mov al,o
    mov c, al
    add c, ch
    mov al,c
    mov o, al
    add o, ch
    jmp mergeSort

ends
introducir_izq:;introducir el numero del puntero izquierdo
    mov ah,cpuntero
    mov puntero, ah
    inc ci
    jmp introducirNum
ends
introducir_der:;introducir el numero del puntero derecho
    mov ah,opuntero
    mov puntero, ah
    inc oi
    jmp introducirNum
ends
    
    

introducirNum:;introducir el numero que esta en el puntero al arreglo temporal
    lea si, arr
    lea di, arr_temp

    mov searchPuntero,0 
    mov ah, puntero

    cmp searchPuntero,ah
        jl irPosicionArr
        je continue1
    irPosicionArr:
        inc si
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArr
    
    continue1:
    mov searchPuntero, 0
    mov ah, max_temp
    
    cmp searchPuntero, ah
        jl irPosicionArrTemp
        je bucleIntroducir
    irPosicionArrTemp:
        inc di
        inc searchPuntero
        cmp searchPuntero, ah
            jl  irPosicionArrTemp

    bucleIntroducir:
        mov dl, [si]
        inc puntero
        
        cmp dl, '.'
            jz salirBucleIntroducir

        mov [di], dl
        inc di
        inc si
        inc max_temp
        

        add dl, 30h
        
        cmp dl, ','
            jz salirBucleIntroducir
        cmp dl, '.'
            jz salirBucleIntroducir
        
        jmp bucleIntroducir

    salirBucleIntroducir:
        inc puntero
        
        jmp mergeSort
ends
rewriteArr:;reescribe el arreglo por el arreglo temporal
    lea si, arr_temp
    lea di, arr
    
    mov puntero,0
    mov ah, max

    whileRewrite:
        mov al, [si]
        mov [di],al
        inc di
        inc si
        inc puntero
        cmp puntero, ah
            jl whileRewrite
    jmp MainMenu
ends

opcion3:;leer el arreglo
    mov ah,09h
    lea dx, op3 ;genera un texto
    int 21h

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h

    mov ah, 2
    lea si, arr
    mov puntero,0
    
    print:
        mov ah, 2
        mov dl, [si]
        add dl,30h
        int 21h

        inc puntero
        inc si
        mov ah, puntero

        cmp ah, max
            jc print
    ends

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h
    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h

    jmp MainMenu
ends

opcion4:;salir del programa
    mov ah,09h
    lea dx, op4 ;genera un texto
    int 21h

    mov ah,09h
    lea dx, space ;genera un espacio
    int 21h
    
    mov ah,4ch
    int 21h;termina la ejecucion
ends

end code