package fpSimulation

import (
	"math"
)

func mcaSpectrum(scen *Scenario, prop *Properties) {
	// DetectorI Format: Z, keVbeta, keValpha, Ibeta, Ialpha
	var nEnergies, nElements int
	var center, counts, std, exponent, prob float64

	nEnergies = len(scen.SpectrumI)
	nElements = len(scen.DetectorI)
	for n := 0; n < nElements; n++ {
		for p := 0; p < 2; p++ {
			center = scen.DetectorI[n][p+1]
			counts = scen.DetectorI[n][p+3]
			std = center*scen.NoiseM + scen.NoiseB
			for k := 0; k < nEnergies; k++ {
				exponent = (-1.0 / 2.0) * math.Pow((scen.SpectrumI[k][0]-center)/std, 2.0)
				prob = (1.0 / (std * math.Sqrt(2.0*math.Pi))) * math.Exp(exponent)
				scen.SpectrumI[k][1] = scen.SpectrumI[k][1] + (prob * 0.02 * counts)
			}
		}
	}
	for k := 0; k < nEnergies; k++ {
		scen.SpectrumI[k][1] = math.Floor(scen.SpectrumI[k][1])
	}
	return
}
