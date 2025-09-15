Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "PEDOTDoping" {
		Species = "BoronActiveConcentration"
		Value = 2.5e+21
	}
	Constant "MEODoping" {
		Species = "BoronActiveConcentration"
		Value = 9e+18
	}
	Constant "PcbmDoping" {
		Species = "ArsenicActiveConcentration"
		Value = 2.2e+18
	}
	Refinement "RefDef.1" {
		MaxElementSize = ( 0.1 0.2 )
		MinElementSize = ( 0.01 0.05 )
	}
	Refinement "RefDef.3" {
		MaxElementSize = ( 0.1 0.02 )
		MinElementSize = ( 0.01 0.005 )
	}
	Refinement "RefDef.4" {
		MaxElementSize = ( 0.1 0.1 )
		MinElementSize = ( 0.01 0.05 )
	}
	Refinement "RefDef.5" {
		MaxElementSize = ( 0.1 0.001 )
		MinElementSize = ( 0.01 0.0001 )
	}
	Refinement "RefDef.6" {
		MaxElementSize = ( 0.1 0.05 )
		MinElementSize = ( 0.01 0.005 )
	}
	Refinement "RefDef.7" {
		MaxElementSize = ( 0.1 0.00125 )
		MinElementSize = ( 0.01 0.0005 )
	}
}

Placements {
	Constant "PEDOTDopingPlacement" {
		Reference = "PEDOTDoping"
		EvaluateWindow {
			Element = material ["PEDOT"]
		}
	}
	Constant "MEODopingPlacement" {
		Reference = "MEODoping"
		EvaluateWindow {
			Element = material ["MEO_2PACz"]
		}
	}
	Constant "PcbmDopingPlacement" {
		Reference = "PcbmDoping"
		EvaluateWindow {
			Element = material ["PCBM"]
		}
	}
	Refinement "RefPlace.1" {
		Reference = "RefDef.1"
		RefineWindow = region ["Metal_Electrode"]
	}
	Refinement "RefPlace.3" {
		Reference = "RefDef.3"
		RefineWindow = region ["ETL"]
	}
	Refinement "RefPlace.4" {
		Reference = "RefDef.4"
		RefineWindow = region ["Absorber"]
	}
	Refinement "RefPlace.5" {
		Reference = "RefDef.5"
		RefineWindow = region ["HTL_buffer"]
	}
	Refinement "RefPlace.6" {
		Reference = "RefDef.6"
		RefineWindow = region ["HTL"]
	}
	Refinement "RefPlace.7" {
		Reference = "RefDef.7"
		RefineWindow = region ["TCO"]
	}
}

