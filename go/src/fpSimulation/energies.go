package fpSimulation

func energies() []float64 {
	var nE int
	nE = (int)((50.00 - 1.00) / 0.02)
	nE = nE + 1
	keV := make([]float64, nE)
	keV[0] = 1.00
	for i := 1; i < nE; i++ {
		keV[i] = keV[i-1] + 0.02
	}
	return keV
}

func closestEi(keVpeak float64) float64 {
	var eVpeakInt int
	var eVpeakFlt float64
	eVpeakInt = (int)(keVpeak * 100)
	if (eVpeakInt % 2) != 0 {
		eVpeakInt = eVpeakInt + 1
	}
	eVpeakFlt = (float64)(eVpeakInt)
	eVpeakFlt = eVpeakFlt / 100.0
	return eVpeakFlt
}

func rowFromE(keV float64) int {
	var row int
	row = (int)((keV - 1.00) / 0.02)
	if row < 0 {
		row = 0
	}
	return row
}

// This doesn't set the energy scales for the peaksI or detectI, because those are not continuous over the energy scale //
func setEnergyScales(scen *Scenario) {
	keV := energies()
	nEnergies := len(keV)
	scen.SrcI = make([][]float64, nEnergies)
	scen.BeamI = make([][]float64, nEnergies)
	scen.MuSample = make([][]float64, nEnergies)
	scen.SpectrumI = make([][]float64, nEnergies)
	for i := 0; i < nEnergies; i++ {
		rowSrc := make([]float64, 2)
		rowSrc[0] = keV[i]
		rowSrc[1] = 0.0
		scen.SrcI[i] = rowSrc
		rowBeam := make([]float64, 2)
		rowBeam[0] = keV[i]
		rowBeam[1] = 0.0
		scen.BeamI[i] = rowBeam
		rowMuSample := make([]float64, 2)
		rowMuSample[0] = keV[i]
		rowMuSample[1] = 0.0
		scen.MuSample[i] = rowMuSample
		rowSpectrum := make([]float64, 2)
		rowSpectrum[0] = keV[i]
		rowSpectrum[1] = 0.0
		scen.SpectrumI[i] = rowSpectrum
	}
}
