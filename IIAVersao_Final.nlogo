;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                      VARIAVEIS
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

breed [moscas mosca]
breed [moscasE moscaE]
breed [ovos ovo]
breed [ratos rato]


moscas-own [fertilidade energia]
moscasE-own [energia]
ovos-own [numMoscas contador]
ratos-own [numOvos]


;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                      SETUP
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

to setup
  clear-all
  setup-patches
  setup-food
  setup-turtles
  reset-ticks
end

;;  ----------------------------------------------------------

; CREATE ENVIRMENT
to setup-patches
  ask patches
  [
    set pcolor green
  ]
end

;;  ----------------------------------------------------------

; CREATE AGENTS (MOSCAS, MOSCAS ESTERIL)
to setup-turtles
  create-moscas nmoscas
  create-moscasE nmoscasE
  create-ratos nratos

  ask turtles
  [
    setxy random-xcor random-ycor
  ]

  ask moscas
  [
    set energia energia_inicial
    set shape "molecule water"
    set color 2
    set size 1
    set fertilidade random 101
    set heading 0
  ]

  ask moscasE
  [
    set energia energia_inicial
    set shape "molecule water"
    set color 7
    set heading 0
  ]

  ask ratos
  [
    set shape "mouse"
    set color 7
    set size 2
  ]
end

;;  ----------------------------------------------------------

; CREATE FOOD
to setup-food

   ask patches [
     if random 101 < comida [
       set pcolor brown
     ]
   ]

end

;;  ----------------------------------------------------------

; GO
to go

  ifelse +OvosEstereis?
  [
    if count turtles = 0 or ticks = 10000 or count turtles = count ratos
    [ stop ]
  ]
  [
    if count turtles = 0 or ticks = 10000 or count turtles = count moscas + count ratos + count ovos
    [ stop ]
  ]

  mais-comida

  ask moscas
  [
    criação
    choca
    comer
    movimento1
    morrer
    if energia > 300
    [
      set energia 300
    ]
    while [count moscas >= 5000]
    [
      ask one-of moscas
      [
        die
      ]
    ]
  ]

  ask moscasE
  [
    transformer
    bully
    movimento2
    morrer
    if energia > 300
    [
      set energia 300
    ]
  ]

  ask ratos
  [
    movimento3
    comerOvos
  ]

  tick

  ; Contador para o choca
   ask ovos
  [
    set contador contador + 1
  ]
end

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                      MOSCAS
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;; PROCREATE
to criação
    if any? moscas-on neighbors4  ; se houver moscas em neighbors4
    [
      ifelse any? ovos-on neighbors  ;  Se existirem ovos em neighbors, não são gerados mais ovos nessa area
      []
      [
          ask one-of moscas-on neighbors4  ; pega numa dessas moscas
          [
          let fertil fertilidade
             if any? moscas-on patch-ahead 1  ; verifica se existe alguma mosca na patch de cima
             [
               ask one-of moscas-on patch-ahead 1  ; pega nessa mosca
               [
                let fertil1 fertilidade  ; guarda a sua fertilidade

                  if not any? ovos-here  ; se não houver ovos criados
                  [
                      hatch-ovos 1  ; gera um ovo
                      [
                         set size 1
                         set color white
                         set shape "egg"
                         let n round((fertil + fertil1) / 20)
                         if n > 100
                         [set n 100]
                         set numMoscas n
                         set contador 0
                      ]
                   set energia round(energia / 2)  ; Uma das moscas no parto fica com metade da energia
                  ]
               ]
             ]

             if any? moscas-on patch-ahead -1  ; verifica se existe alguma mosca na patch de baixo
             [
               ask one-of moscas-on patch-ahead -1  ; pega nessa mosca
               [
                let fertil1 fertilidade  ; guarda a sua fertilidade
                  if not any? ovos-here  ; se não houver ovos criados
                  [
                      hatch-ovos 1  ; gera um ovo
                      [
                         set size 1
                         set color white
                         set shape "egg"
                         let n round((fertil + fertil1) / 20)
                         if n > 100
                         [set n 100]
                         set numMoscas n
                         set contador 0
                      ]
              set energia round(energia / 2) ; Uma das moscas no parto fica com metade da energia
                  ]
               ]
             ]

             if any? moscas-on patch-right-and-ahead 90 1  ; verifica se existe alguma mosca na patch de baixo
             [
               ask one-of moscas-on patch-right-and-ahead 90 1  ; pega nessa mosca
               [
                let fertil1 fertilidade  ; guarda a sua fertilidade
                  if not any? ovos-here  ; se não houver ovos criados
                  [
                      hatch-ovos 1  ; gera um ovo
                      [
                         set size 1
                         set color white
                         set shape "egg"
                         let n round((fertil + fertil1) / 20)
                         if n > 100
                         [set n 100]
                         set numMoscas n
                         set contador 0
                      ]
              set energia round(energia / 2) ; Uma das moscas no parto fica com metade da energia
                  ]
               ]
             ]

             if any? moscas-on patch-right-and-ahead 90 1  ; verifica se existe alguma mosca na patch de baixo
             [
               ask one-of moscas-on patch-right-and-ahead 90 1  ; pega nessa mosca
               [
                let fertil1 fertilidade  ; guarda a sua fertilidade
                  if not any? ovos-here  ; se não houver ovos criados
                  [
                      hatch-ovos 1  ; gera um ovo
                      [
                         set size 1
                         set color white
                         set shape "egg"
                         let n round((fertil + fertil1) / 20)
                         if n > 100
                         [set n 100]
                         set numMoscas n
                         set contador 0
                      ]
              set energia round(energia / 2) ; Uma das moscas no parto fica com metade da energia
                  ]
               ]
             ]

          jump 1   ; Para que as moscas não se concentrem num local
          ]
      ]
  ]

end

;;  ----------------------------------------------------------

to choca
  ask ovos
  [
    if contador >= 10   ;  Contador = Temporizador que ao chegar aos 10 ticks > choca os ovos
    [

     ifelse +OvosEstereis?   ; Ovos podem chocar moscas "normais" e moscas estereis
     [
         ifelse random 101 < 40   ; Probabilidade de as moscas chocadas serem "normais" = 40%
         [
           hatch-moscas numMoscas
           [
             set shape "molecule water"
             set color 2
             set fertilidade random 101
             set energia energia_inicial
           ]
          jump 1    ; Para que as moscas não se comecem a reproduzir à nascença
         ]
         [
           hatch-moscasE numMoscas
           [
             set shape "molecule water"
             set color 7
             set energia energia_inicial
           ]
          jump 1    ; Para que as moscas não se comecem a reproduzir à nascença
         ]
      ]
      [
          hatch-moscas numMoscas
           [
             set shape "molecule water"
             set color 2
             set fertilidade random 101
             set energia energia_inicial
           ]
        jump 1    ; Para que as moscas não se comecem a reproduzir à nascença
      ]
        die   ; Ovo desaparece depois das moscas nascerem
    ]
  ]
end


;;  ----------------------------------------------------------
;; COMER
to comer
     if any? neighbors4 with [pcolor = brown]    ; Existe comida em neighbors4 ?
     [
        let food one-of neighbors4 with [pcolor = brown]   ; Guarda a sua localização na variavel local "food"
               face food ; orienta para food
               move-to food ; move se para food
               set pcolor green  ; comida "desaparece"
               set energia energia + energia_comida  ; Energia é aumentada depois de comer
     ]
end

to movimento1

  ifelse any? neighbors4 with [pcolor = green] and count turtles = 0  ; Se houver um espaço vazio ( sem comida ) e sem ovos
        [
              let vazio one-of neighbors4 with [pcolor = green]  ; Guarda a localizaoção na variavel local vazio
                face vazio ; orienta se para vazio
                move-to vazio ; move se para vazio
        ]
        [
    E/D?  ; Se o espaço vazio não existir move se para a esquerda ou direita aleatoriamente
        ]
  set energia energia - 1  ; perde 1 de energia ao mover se

end

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                      MOSCA ESTERIL
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;; INTERACAO ENTRE TURTLES

to bully
  ; Energia da mosca que anda à procura de adversário
   let energiaMosca energia
   if any? turtles-on neighbors
   [
    if any? moscas-on neighbors   ; Se encontrar uma mosca rouba-lhe parte da sua fertilidade
    [
      ask one-of moscas-on neighbors
      [
        let novo round(fertilidade - (fertilidade * (roubaFertilidade / 100)))  ; Formula para o roubo da fertilidade
        let nova_energia (energia - (energia_comida * 1.5))  ; Mosca esteril rouba 1.5 * a percentagem de energia que a comida dá à mosca "normal"
        set fertilidade novo
        set energia nova_energia
      ]
    ]

    if any? moscasE-on neighbors   ; Se encontrar uma moscas esteril desafia-a para um duelo épico até à morte
    [
      ; Se morre se mantiver como 0 , moscaAdversaria morre
        let morre 0
        let energiaAdversario 0

      ask one-of moscasE-on neighbors
      [
           set energiaAdversario energia

           if energiaMosca > energiaAdversario and (energiaMosca - energiaAdversario) / 100 > 0.1
           [
             die
           ]

           if energiaMosca < energiaAdversario and (energiaAdversario - energiaMosca) / 100 > 0.1
           [
             set morre 1
             set energia energia + energiaMosca
           ]
       ]

         ifelse morre = 0
         [
           set energia energia + energiaAdversario
         ]
         [
           die
         ]
     ]

    if any? ovos-on neighbors   ; Se encontrar um ovos, diminui o numero de moscas dentro do ovo em 1a unidade
    [
       ask one-of ovos-on neighbors
      [
        if numMoscas > 0
        [
        set numMoscas numMoscas - 1
        ]
      ]
    ]
   ]
end

to movimento2
      ; melhorPosicao pergunta : Existem turtles nas vizinhanças desta patch?
      let melhorPosicao? any? moscas-on neighbors or any? ovos-on neighbors
        ifelse melhorPosicao? ; Se houverem turtles
        [
            ; destino = Encontra a vizinhança mais populada e guarda as suas "coordenadas"
            let destino max-one-of neighbors [count moscas-here + count ovos-here]
            face destino
            move-to destino
        ]
        [ E/D? ]
      set energia energia - 1
end

to transformer
  if count moscasE-on patch-here > 2 ; Se existirem mais que duas moscas estereis nesta patch então...
  [
    set breed moscas
    set color black
    set shape "molecule water"
    set size 1
    set fertilidade random 101

    let transform? count moscas-on neighbors  ; Guarda o numero de moscas em neighbors
    let me 0  ; Guarda 0 na variavel local de maior energia
    ifelse any? moscas-on neighbors
    [
      while [transform? > 0]   ; Enquanto existirem moscas em neighbors, faz...
      [
        ask one-of moscas-on neighbors
        [
          ifelse energia > me ; Encontra a maior energia e guarda em 'me'
          [
            set me energia
            die   ; mata a mosca esteril
          ]
          [
            die   ; mata a mosca esteril
          ]
        ]
        set transform? transform? - 1  ; diminui o numero de moscas
      ]
      set energia me  ; coloca a energia como o valor da energia maior
    ]
    [
      set energia 1  ; se nao houver energia maior coloca essa energia a 1
    ]
  ]
end

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                       RATOS
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

to movimento3

  ifelse any? ovos-on neighbors  ; Se existirem ovos em neighbors
  [
    let destino max-one-of neighbors [count ovos-here]  ; Guarda a posicao com mais ovos na variavel local em destino
    face destino   ; orienta se para destino
    move-to destino  ; move se para destino
  ]
  [
    E/D?  ; Se o espaço vazio não existir move se para a esquerda ou direita aleatoriamente
  ]

end

to comerOvos
  if any? ovos-here ; Se houver algum ovo na patch atual
  [
    ask ovos-here
    [
      die  ; o ovo é comido
    ]
    set numOvos numOvos + 1 ; numMoscas = variavel que guarda o numero de ovos comidos pelo rato
  ]
end

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;                      UTILS
;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; Vai para a direita ou para a esquerda?
to E/D?
  ifelse random 101 < 50
  [
    right 90
    fd 1
  ]
  [
    left 90
    fd 1
  ]
end

;; Morreu ?
to morrer

    if energia <= 0
    [
      die
    ]

end

;; Mais Comida
to mais-comida
  if ComidaConstante?
  [
    ;; Enquanto o numero for inferior a determinada constante, + comida é gerada
    while [count patches with [pcolor = brown] < ((max-pxcor * 2 + 1) * ( max-pycor * 2 + 1)) / (100 / comida)] ; A comida não baixa de uma certa constante definida pela formula anterior ( porque está a ser gerada, enquanto é comida )
    [
      ask one-of patches with [pcolor = green]
      [
        set pcolor brown
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
26
20
649
644
-1
-1
15.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
1
ticks
30.0

SLIDER
682
295
854
328
energia_comida
energia_comida
1
50
30.0
1
1
NIL
HORIZONTAL

BUTTON
26
661
651
694
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
29
706
652
739
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
682
338
854
371
comida
comida
5
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
687
126
859
159
nmoscas
nmoscas
0
50
15.0
1
1
NIL
HORIZONTAL

SLIDER
687
165
859
198
nmoscasE
nmoscasE
0
50
15.0
1
1
NIL
HORIZONTAL

SLIDER
677
518
849
551
roubaFertilidade
roubaFertilidade
0
10
5.0
1
1
NIL
HORIZONTAL

MONITOR
1085
126
1171
171
Moscas vivas
count moscas
17
1
11

MONITOR
938
128
1071
173
Moscas Estereis vivas
count moscasE
17
1
11

MONITOR
1192
127
1249
172
Ovos
count ovos
17
1
11

SLIDER
682
424
854
457
energia_inicial
energia_inicial
1
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
954
384
1097
417
+OvosEstereis?
+OvosEstereis?
1
1
-1000

TEXTBOX
687
98
837
117
Quantidade Turtles:\n
15
0.0
1

TEXTBOX
689
268
839
287
Comida : 
15
0.0
1

TEXTBOX
691
400
841
419
Energia : 
15
0.0
1

TEXTBOX
956
355
1106
374
Condições Adicionais:
15
0.0
1

TEXTBOX
946
53
1096
78
Monitores :\n
20
0.0
1

SWITCH
954
433
1113
466
ComidaConstante?
ComidaConstante?
1
1
-1000

MONITOR
941
227
998
272
comida
count patches with [pcolor = brown]
17
1
11

SLIDER
688
202
860
235
nratos
nratos
0
10
0.0
1
1
NIL
HORIZONTAL

TEXTBOX
943
101
1093
119
Turtles
13
0.0
1

TEXTBOX
943
193
1093
211
Patches
14
0.0
1

TEXTBOX
685
496
835
515
Fertilidade : 
15
0.0
1

TEXTBOX
722
51
872
76
Sliders : 
20
0.0
1

TEXTBOX
949
312
1099
337
Switches :
20
0.0
1

PLOT
1364
110
1781
324
Moscas vs MoscasE
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count moscas"
"pen-1" 1.0 0 -7500403 true "" "plot count moscasE"

TEXTBOX
1431
58
1581
83
Gráfico:
20
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

egg
false
0
Circle -7500403 true true 96 76 108
Circle -7500403 true true 72 104 156
Polygon -7500403 true true 221 149 195 101 106 99 80 148

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hawk
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -7500403 true true 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -7500403 true true 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -7500403 true true 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

molecule water
true
0
Circle -1 true false 183 63 84
Circle -16777216 false false 183 63 84
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150
Circle -1 true false 33 63 84
Circle -16777216 false false 33 63 84

mouse
true
0
Polygon -7500403 true true 144 238 153 255 168 260 196 257 214 241 237 234 248 243 237 260 199 278 154 282 133 276 109 270 90 273 83 283 98 279 120 282 156 293 200 287 235 273 256 254 261 238 252 226 232 221 211 228 194 238 183 246 168 246 163 232
Polygon -7500403 true true 120 78 116 62 127 35 139 16 150 4 160 16 173 33 183 60 180 80
Polygon -7500403 true true 119 75 179 75 195 105 190 166 193 215 165 240 135 240 106 213 110 165 105 105
Polygon -7500403 true true 167 69 184 68 193 64 199 65 202 74 194 82 185 79 171 80
Polygon -7500403 true true 133 69 116 68 107 64 101 65 98 74 106 82 115 79 129 80
Polygon -16777216 true false 163 28 171 32 173 40 169 45 166 47
Polygon -16777216 true false 137 28 129 32 127 40 131 45 134 47
Polygon -16777216 true false 150 6 143 14 156 14
Line -7500403 true 161 17 195 10
Line -7500403 true 160 22 187 20
Line -7500403 true 160 22 201 31
Line -7500403 true 140 22 99 31
Line -7500403 true 140 22 113 20
Line -7500403 true 139 17 105 10

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count moscas</metric>
    <metric>count moscasE</metric>
    <metric>ticks</metric>
    <enumeratedValueSet variable="nmoscasE">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nmoscas">
      <value value="15"/>
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nratos">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energia_inicial">
      <value value="50"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roubaFertilidade">
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energia_comida">
      <value value="15"/>
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="comida">
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="+OvosEstereis?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ComidaConstante?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
