package fpSimulation

import (
	"math"
)

// This currently only handles Kalpha and Kbeta lines
// characteristics : Z, Edge, Kb, Ka, epsilon Kb, epsilon Ka
// Sample Format : Z, Ci(wtF)
// Output Format: Z, keVbeta, keValpha, Ibeta, Ialpha

func calculatePeaks(scen *Scenario, prop *Properties) {
	var nEnergies, nElements int
	var Pfluor, Sfluor, Ifluor float64

	sampleConfig(scen, prop)

	nEnergies = len(scen.BeamI)
	nElements = len(scen.Sample)
	for k := 0; k < nEnergies; k++ {
		for i := 0; i < nElements; i++ {
			for pi := 0; pi < 2; pi++ {
				Pfluor = primaryFluor(k, i, pi, scen, prop)
				Sfluor = 0.0
				for j := 0; j < nElements; j++ {
					for pj := 0; pj < 2; pj++ {
						Sfluor = Sfluor + secondaryFluor(Pfluor, k, i, pi, j, pj, scen, prop)
					}
				}
				Ifluor = scen.BeamI[k][1] * (Pfluor + Sfluor) * 0.02
				scen.PeaksI[i][pi+3] = scen.PeaksI[i][pi+3] + Ifluor
			}
		}
	}
	return
}

func primaryFluor(k int, i int, pi int, scen *Scenario, prop *Properties) float64 {
	var zi int
	var Pfluor, Ci, angleCorr, keV, keVedgeI, keVlineI, epsilonI float64
	var tauIE, muE, muLineI float64

	Pfluor = 0.0
	zi = (int)(scen.Sample[i][0])
	Ci = scen.Sample[i][1]
	if zi <= scen.MaxZ {
		angleCorr = math.Sin(45.0 * (math.Pi / 180.0))
		keV = scen.MuSample[k][0]
		keVedgeI = prop.Char[zi-1][1]
		keVlineI = prop.Char[zi-1][2+pi]
		epsilonI = prop.Char[zi-1][4+pi]
		tauIE = prop.Tau[k][zi]
		muE = scen.MuSample[k][1] / angleCorr
		muLineI = scen.MuSample[rowFromE(keVlineI)][1] / angleCorr
		if keV > keVedgeI {
			Pfluor = (scen.GeomFactor / angleCorr) * Ci * epsilonI * (tauIE / (muE + muLineI))
		}
	}
	return Pfluor
}

// Note that Ji(lambda_j)/Ji(lambda) is treated as 1 because JK is energy independent
func secondaryFluor(Pfluor float64, k int, i int, pi int, j int, pj int, scen *Scenario, prop *Properties) float64 {
	var zi, zj int
	var Sfluor, Cj, angleCorr, keV, keVedgeI, keVlineI, keVedgeJ, keVlineJ, epsilonJ float64
	var tauIE, tauJE, tauIlineJ, muE, muLineI, muLineJ, L float64

	Sfluor = 0.0
	zi = (int)(scen.Sample[i][0])
	zj = (int)(scen.Sample[j][0])
	Cj = scen.Sample[j][1]
	if (zi <= scen.MaxZ) && (zj <= scen.MaxZ) {
		angleCorr = math.Sin(45.0 * (math.Pi / 180.0))
		keV = scen.MuSample[k][0]
		keVedgeI = prop.Char[zi-1][1]
		keVlineI = prop.Char[zi-1][2+pi]
		keVedgeJ = prop.Char[zj-1][1]
		keVlineJ = prop.Char[zj-1][2+pj]
		epsilonJ = prop.Char[zj-1][4+pj]
		tauIE = prop.Tau[k][zi]
		tauJE = prop.Tau[k][zj]
		tauIlineJ = prop.Tau[rowFromE(keVlineJ)][zi]
		muE = scen.MuSample[k][1] / angleCorr
		muLineI = scen.MuSample[rowFromE(keVlineI)][1] / angleCorr
		muLineJ = scen.MuSample[rowFromE(keVlineJ)][1] // No angle correction for this term!
		if (keV > keVedgeI) && (keV > keVedgeJ) && (keVlineJ > keVedgeI) {
			L = (muLineJ/muLineI)*math.Log(1.0+(muLineI/muLineJ)) + (muLineJ/muE)*math.Log(1.0+(muE/muLineJ))
			Sfluor = 0.5 * Pfluor * Cj * epsilonJ * ((tauJE * tauIlineJ) / (tauIE * muLineJ)) * L
		}
	}
	return Sfluor
}
