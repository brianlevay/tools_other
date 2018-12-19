package fpSimulation

func NewScenario() *Scenario {
	scen := new(Scenario)
	scen.Error = false
	scen.MaxZ = 56
	setEnergyScales(scen)
	return scen
}

func sampleConfig(scen *Scenario, prop *Properties) {
	createPeakArrays(scen, prop)
	createMuSample(scen, prop)
}

func createPeakArrays(scen *Scenario, prop *Properties) {
	var nElements, zi int

	nElements = len(scen.Sample)
	scen.PeaksI = make([][]float64, nElements)
	scen.DetectorI = make([][]float64, nElements)
	for i := 0; i < nElements; i++ {
		rowPks := make([]float64, 5)
		rowDet := make([]float64, 5)
		zi = (int)(scen.Sample[i][0])
		rowPks[0] = scen.Sample[i][0]
		rowDet[0] = scen.Sample[i][0]
		if zi <= scen.MaxZ {
			rowPks[1] = prop.Char[zi-1][2]
			rowPks[2] = prop.Char[zi-1][3]
			rowDet[1] = prop.Char[zi-1][2]
			rowDet[2] = prop.Char[zi-1][3]
		} else {
			rowPks[1] = 0.0
			rowPks[2] = 0.0
			rowDet[1] = 0.0
			rowDet[2] = 0.0
		}
		rowPks[3] = 0.0
		rowPks[4] = 0.0
		rowDet[3] = 0.0
		rowDet[4] = 0.0
		scen.PeaksI[i] = rowPks
		scen.DetectorI[i] = rowDet
	}
	return
}

func createMuSample(scen *Scenario, prop *Properties) {
	var nEnergies, nElements, zi int
	var Ci float64

	nEnergies = len(scen.BeamI)
	nElements = len(scen.Sample)
	for k := 0; k < nEnergies; k++ {
		for i := 0; i < nElements; i++ {
			zi = (int)(scen.Sample[i][0])
			Ci = scen.Sample[i][1]
			if zi < scen.MaxZ {
				scen.MuSample[k][1] = scen.MuSample[k][1] + (Ci * prop.Mu[k][zi])
			}
		}
	}
	return
}
