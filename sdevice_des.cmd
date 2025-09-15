#setdep @previous@


File {
  grid= "@tdr@"
  IlluminationSpectrum = "/jumbo/scheidelerlab/Vann/FinalTests/Measured_Spectra/am15g_downsampled.txt"
  Plot= "@tdrdat@"
  Current= "@plot@"
  Output= "@log@"
  Parameter= "@parameter@"
}

*--------------------------------------------------
Electrode {   
  { name="pContact" voltage= 0.0 DistResist= @TCO_res@ }
    * Schottky Barrier = 2.8
  { name="nContact" voltage= 0.0 resist= 1e+3 } 
    * Schottky Barrier = 0.8
}

*--------------------------------------------------
Plot {
  DopingConcentration BoronActiveConcentration PhosphorusActiveConcentration
  BandGap ConductionBandEnergy ValenceBandEnergy ElectronAffinity 
  eCurrent/Vector hCurrent/Vector current/vector
  SpaceCharge eDensity hDensity
  Potential
  eMobility hMobility
  SRHRecombination AugerRecombination TotalRecombination SurfaceRecombination
RadiativeRecombination eLifeTime hLifeTime
  EffectiveIntrinsicDensity IntrinsicDensity
  OpticalIntensity
  OpticalGeneration
  MetalConductivity
}

CurrentPlot{
  OpticalGeneration(Integrate(Semiconductor) )
  OpticalGeneration(Integrate(material="Perovskite") )
  SRH(Integrate(Semiconductor))
  Auger(Integrate(Semiconductor))
  ModelParameter="Wavelength"
}

*--------------------------------------------------

Physics {

  Recombination(
    Auger
    SRH
    Band2Band
  )
  Mobility()
  *EffectiveIntrinsicDensity (BandGapNarrowing (JainRoulston))
    
  Optics (
    ComplexRefractiveIndex(WavelengthDep(Real Imag))
    OpticalGeneration(
      QuantumYield(StepFunction(EffectiveBandgap))
      ComputeFromSpectrum(
        Scaling = @sun@
      )      
    )
    Excitation(
      Theta = 180
      Polarization= 0.5
      Window (
	Origin = (@<@xlen@*0.5>@, @<1*@glass_length@>@)
	OriginAnchor = Center
	Line ( Dx = @xlen@ )
      )
    ) 
    OpticalSolver (  

		  TMM (
			IntensityPattern=  Envelope 
			LayerStackExtraction (
				Position = (@<@xlen@*0.5>@, @<1*@glass_length@>@) *middle of window
				Mode = RegionWise  
				Medium (
					Location= bottom
					Material= "Silver"
				)
			)*end LayerStackExtraction
		) *end TMM
    )
  )
} 






*--------------------------------------------------
Math{
  Extrapolate 
  Derivatives
  ExitOnFailure
  Iterations= 30
 CNormPrint
 -CheckUndefinedModels
  Method= ILS
  ILSrc=
  "set(1){
    iterative(gmres(100), tolrel=1e-10, tolunprec=1e-8, tolabs=0, maxit=200);
    preconditioning(ilut(0.0001,-1),left);
    ordering (symmetric=nd, nonsymmetric=mpsilst);
    options(compact=yes, linscale=0, refineresidual=8, verbose=5); }; " 


}

*--------------------------------------------------
Solve{

NewCurrentPrefix= "tmp_"

  Poisson
  Coupled {Poisson Electron Hole Contact} 

 
NewCurrentPrefix= ""	

  Plot(FilePrefix= "n@node@_jsc")


  Quasistationary ( 
    InitialStep= 0.1 MaxStep= 0.1 MinStep= 1e-6 DoZero
    Goal{ Name= "pContact" voltage= 0.6 }
    ){ Coupled {Poisson Electron Hole Contact} } 
  Plot(FilePrefix= "n@node@_op")

  Quasistationary ( 
    InitialStep= 0.05 MaxStep= 0.05 MinStep= 1e-6
    Goal{ Name= "pContact" voltage= 1.2}
    ){ Coupled {Poisson Electron Hole Contact} } 

  System("rm -f tmp_*")

}


