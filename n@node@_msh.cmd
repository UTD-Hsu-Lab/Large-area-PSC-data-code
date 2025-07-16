Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	AnalyticalProfile "1d_opt_def" {
		Function = SubMesh1d(datafile = "./no_contact_optical_@cell_thickness@.plx", scale = 1, range = line[ (0), (1000) ])
		LateralFunction = Erf(Factor = 0)
	}
	AnalyticalProfile "frontDop_def" {
		Species = "PhosphorusActiveConcentration"
		Function = Gauss(PeakPos = 0, PeakVal = 6e+18, Length = 0.2)
		LateralFunction = Erf(Factor = 0)
	}
}

Placements {
	Constant "subDop_place" {
		Reference = "subDop_def"
		EvaluateWindow {
			Element = region ["substrate"]
		}
	}
}

