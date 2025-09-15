(sde:clear)

(sdegeo:set-default-boolean "ABA")

(define cntlen @<@cntlen@*@xlen@>@ ); contact length
(define xlen @<@xlen@ + 2*@cntlen@*@xlen@>@)

(define nanowires_len @nanowires_length@)
(define absorber_length 0.25)

(sdegeo:create-rectangle (position 0 -0.155 0) (position xlen -0.205 0) 
 "Silver" "Metal_Electrode")
(sdegeo:create-rectangle (position 0 -0.055 0) (position xlen -0.155 0) 
 "Aluminum" "Metal_Electrode")
(sdegeo:create-rectangle (position 0 0 0) (position xlen -0.055 0) 
 "PCBM" "ETL")
(sdegeo:create-rectangle (position 0 0 0) (position xlen absorber_length 0) 
 "Perovskite" "Absorber")
(sdegeo:create-rectangle (position 0 absorber_length 0) (position xlen  (+ absorber_length 0.005) 0) 
 "MEO_2PACz" "HTL_buffer")
(sdegeo:create-rectangle (position 0 (+ absorber_length 0.005) 0) (position xlen  (+ absorber_length 0.054) 0) 
 "PEDOT" "HTL")
(sdegeo:create-rectangle (position 0 (+ absorber_length 0.054) 0) (position xlen  (+ absorber_length 0.054 nanowires_len) 0) 
 "Nanowires_v2" "TCO")


;glass or PET layer for substrate
; (sdegeo:create-cuboid (position xlen ylen  (+ absorber_length 0.124))  (position xlen ylen (+ absorber_length 1.124) ) 
; "SiO2" "Glass")


;contacts
(sdegeo:define-contact-set "nContact" 4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "pContact" 4 (color:rgb 0 0 1) "##")


;(sdegeo:insert-vertex (position cntlen -0.205 0.0))
(sdegeo:insert-vertex (position (- xlen cntlen) (+ absorber_length 0.054 nanowires_len) 0.0))

(sdegeo:set-current-contact-set "nContact")
(sdegeo:define-2d-contact (find-edge-id (position (/ cntlen 2) -0.205 0))
(sdegeo:get-current-contact-set))

(sdegeo:set-current-contact-set "pContact")
(sdegeo:define-2d-contact (find-edge-id (position (- xlen (/ cntlen 2)) (+ absorber_length 0.054 nanowires_len) 0))
(sdegeo:get-current-contact-set))



;meshes
(define xMax (/ xlen 10) )
(define xMin (/ xlen 100) )




;Ag and Al mesh
(sdedr:define-refinement-region "RefPlace.1" "RefDef.1" "Metal_Electrode")
(sdedr:define-refinement-size "RefDef.1" xMax 0.2 xMin 0.05 )

;pcbm etl mesh
(sdedr:define-refinement-region "RefPlace.3" "RefDef.3" "ETL")
(sdedr:define-refinement-size "RefDef.3" xMax 0.02 xMin 0.005 )

;pvsk mesh
(sdedr:define-refinement-region "RefPlace.4" "RefDef.4" "Absorber")
(sdedr:define-refinement-size "RefDef.4" xMax 0.1 xMin 0.05 )
;meo mesh
(sdedr:define-refinement-region "RefPlace.5" "RefDef.5" "HTL_buffer")
(sdedr:define-refinement-size "RefDef.5" xMax 0.001 xMin 0.0001 )

;pedot htl mesh
(sdedr:define-refinement-region "RefPlace.6" "RefDef.6" "HTL")
(sdedr:define-refinement-size "RefDef.6" xMax  0.05 xMin  0.005 )

;nanowires mesh
(sdedr:define-refinement-region "RefPlace.7" "RefDef.7" "TCO")
(sdedr:define-refinement-size "RefDef.7" xMax (/ nanowires_len 4) xMin (/ nanowires_len 10) )


;doping

(sdedr:define-constant-profile "PEDOTDoping" "BoronActiveConcentration" 2.5e+19) ;originally 2.5e21
(sdedr:define-constant-profile-material "PEDOTDopingPlacement" "PEDOTDoping" "PEDOT")

(sdedr:define-constant-profile "nanowireDoping" "ArsenicActiveConcentration" 1e+19)
(sdedr:define-constant-profile "nanowireDoping" "BoronActiveConcentration" 1e+19)
(sdedr:define-constant-profile-material "nanowireDopingPlacement" "nanowireDoping" "Nanowires_v2")

(sdedr:define-constant-profile "MEODoping" "BoronActiveConcentration" 1e+16)
(sdedr:define-constant-profile-material "MEODopingPlacement" "MEODoping" "MEO_2PACz")

(sdedr:define-constant-profile "PcbmDoping" "ArsenicActiveConcentration" 2.2e+16)
(sdedr:define-constant-profile-material "PcbmDopingPlacement" "PcbmDoping" "PCBM")

(sde:build-mesh " -m 1000000 " "n@node@_msh")

sde:save-model "perovskite_model"
