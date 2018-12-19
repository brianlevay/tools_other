package fpSimulation

import (
	"math"
)

func attenuateSource(scen *Scenario, prop *Properties) {
	// SrcI Format : keV, I
	// Path Materials Format : Material#, Z, Ci(wtF), rho(g/cm3), t(cm)
	var nEnergies, nPathRows, zBeam int
	var exponentSum, Ci, rho, thickness, muAtEi float64

	nEnergies = len(scen.SrcI)
	nPathRows = len(scen.BeamPath)
	for k := 0; k < nEnergies; k++ {
		exponentSum = 0.0
		for r := 0; r < nPathRows; r++ {
			zBeam = (int)(scen.BeamPath[r][1])
			if zBeam <= scen.MaxZ {
				Ci = scen.BeamPath[r][2]
				rho = scen.BeamPath[r][3]
				thickness = scen.BeamPath[r][4]
				muAtEi = prop.Mu[k][zBeam]
				exponentSum = exponentSum + (-muAtEi * Ci * rho * thickness)
			}
		}
		scen.BeamI[k][1] = scen.SrcI[k][1] * math.Exp(exponentSum)
	}
	return
}

func attenuatePeaks(scen *Scenario, prop *Properties) {
	// PeaksI Format: Z, keVbeta, keValpha, Ibeta, Ialpha
	// Path Materials Format : Material#, Z, Ci(wtF), rho(g/cm3), t(cm)
	var nElements, nPathRows, zDet, k int
	var exponentSum, Ci, rho, thickness, muAtEi float64

	nElements = len(scen.PeaksI)
	nPathRows = len(scen.DetectorPath)
	for n := 0; n < nElements; n++ {
		for p := 0; p < 2; p++ {
			exponentSum = 0.0
			k = rowFromE(scen.PeaksI[n][p+1])
			for r := 0; r < nPathRows; r++ {
				zDet = (int)(scen.DetectorPath[r][1])
				if zDet <= scen.MaxZ {
					Ci = scen.DetectorPath[r][2]
					rho = scen.DetectorPath[r][3]
					thickness = scen.DetectorPath[r][4]
					muAtEi = prop.Mu[k][zDet]
					exponentSum = exponentSum + (-muAtEi * Ci * rho * thickness)
				}
			}
			scen.DetectorI[n][p+3] = scen.PeaksI[n][p+3] * math.Exp(exponentSum)
		}
	}
	return
}
