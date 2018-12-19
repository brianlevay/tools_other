package fpSimulation

import (
	"fmt"
)

func Simulate(scen *Scenario, prop *Properties) {
	scen.KeVsrc = 9.0
	scen.MA = 0.250
	scen.Sr = 0.015
	scen.ThetaIn = 78.0
	scen.ThetaOut = 12.0
	scen.ContMult = 1.0
	scen.CharMult = 0.1
	sourceIntensity(scen, prop)

	// Path Materials Format : Material#, Z, Ci(wtF), rho(g/cm3), t(cm)
	beamMaterials := [][]float64{{1.0, 4.0, 1.00, 1.85, 0.0125},
		{2.0, 6.0, 0.85, 0.94, 0.0004},
		{2.0, 1.0, 0.15, 0.94, 0.0004},
		{3.0, 2.0, 1.00, 0.000179, 3.00},
		{4.0, 6.0, 0.85, 0.94, 0.0004},
		{4.0, 1.0, 0.15, 0.94, 0.0004},
		{5.0, 6.0, 0.85, 0.94, 0.0004},
		{5.0, 1.0, 0.15, 0.94, 0.0004}}
	scen.BeamPath = beamMaterials
	attenuateSource(scen, prop)

	// Sample Format : Z, Ci(wtF)
	sample := [][]float64{{14.0, 0.243},
		{13.0, 0.041},
		{26.0, 0.090},
		{20.0, 0.061},
		{12.0, 0.030},
		{11.0, 0.007},
		{22.0, 0.012},
		{19.0, 0.004},
		{8.0, 0.512}}
	scen.Sample = sample
	scen.GeomFactor = 0.5
	calculatePeaks(scen, prop)

	detectorMaterials := [][]float64{{1.0, 6.0, 0.85, 0.94, 0.0004},
		{1.0, 1.0, 0.15, 0.94, 0.0004},
		{2.0, 6.0, 0.85, 0.94, 0.0004},
		{2.0, 1.0, 0.15, 0.94, 0.0004},
		{3.0, 2.0, 1.00, 0.000179, 1.00},
		{4.0, 4.0, 1.00, 1.85, 0.00125},
		{5.0, 14.0, 1.00, 2.16, 0.00005}}
	scen.DetectorPath = detectorMaterials
	attenuatePeaks(scen, prop)

	fwhmSi := 0.100
	fwhmFe := 0.150
	scen.NoiseM = ((fwhmFe / 2.355) - (fwhmSi / 2.355)) / (6.39 - 1.74)
	scen.NoiseB = (fwhmFe / 2.355) - scen.NoiseM*6.39
	mcaSpectrum(scen, prop)

	fmt.Println("Simulation Complete!")
	return
}
