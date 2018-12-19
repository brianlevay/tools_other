package fpSimulation

import (
	"math"
)

func sourceIntensity(scen *Scenario, prop *Properties) {
	var contI, charI float64
	var keVi, keVline, keVedge float64
	var nEnergies, nPeaks int

	co := sourceConstants(scen)

	nEnergies = len(scen.SrcI)
	for k := 0; k < nEnergies; k++ {
		keVi = scen.SrcI[k][0]
		if keVi <= scen.KeVsrc {
			contI = calculateContEi(k, co, scen, prop)
			if contI > 1 {
				scen.SrcI[k][1] = contI
			}
		} else {
			break
		}
	}
	nPeaks = len(prop.Rh)
	for p := 0; p < nPeaks; p++ {
		keVline = prop.Rh[p][1]
		keVedge = prop.Rh[p][2]
		if keVedge <= scen.KeVsrc {
			keVi := closestEi(keVline)
			if keVi <= 50.0 {
				k := rowFromE(keVi)
				charI = calculateCharEi(k, p, co, scen, prop)
				scen.SrcI[k][1] = scen.SrcI[k][1] + charI
			}
		}
	}
	return
}

func sourceConstants(scen *Scenario) *SourceConst {
	co := new(SourceConst)
	co.zInt = 45
	co.zFlt = 45.0
	co.bremC = 1.36 * math.Pow(10.0, 9.0)
	co.bremX = 1.0314 - 0.0032*co.zFlt + 0.0047*scen.KeVsrc
	co.angleTerm = math.Sin(scen.ThetaIn*(math.Pi/180.0)) / math.Sin(scen.ThetaOut*(math.Pi/180.0))
	co.ATerm = 102.906
	co.mTerm = 0.1382 - (0.9211 / math.Pow(co.zFlt, 0.5))
	co.JTerm = 0.0135 * co.zFlt
	co.nTerm = math.Pow(scen.KeVsrc, co.mTerm) * (0.1904 - 0.2236*math.Log(co.zFlt) + 0.1292*math.Pow(math.Log(co.zFlt), 2.0) - 0.0149*math.Pow(math.Log(co.zFlt), 3.0))
	co.rhozmTerm = (co.ATerm / co.zFlt) * (0.787*math.Pow(10.0, -5.0)*math.Sqrt(co.JTerm)*math.Pow(scen.KeVsrc, 1.5) + 0.735*math.Pow(10.0, -6.0)*math.Pow(scen.KeVsrc, 2.0))
	co.rhozbarTerm = (0.49269 - 1.0987*co.nTerm + 0.78557*math.Pow(co.nTerm, 2.0))
	return co
}

func calculateContEi(k int, co *SourceConst, scen *Scenario, prop *Properties) float64 {
	var keVi, tauAtEi, Uo, lnUo, rhozbar, corrTerm, fChi, bremI, contI float64

	keVi = scen.SrcI[k][0]
	tauAtEi = prop.Tau[k][co.zInt+1]

	Uo = scen.KeVsrc / keVi
	lnUo = math.Log(Uo)
	rhozbar = (co.rhozmTerm * co.rhozbarTerm * lnUo) / (0.70256 - 1.09865*co.nTerm + 1.0046*math.Pow(co.nTerm, 2.0) + lnUo)
	corrTerm = 2.0 * tauAtEi * rhozbar * co.angleTerm
	fChi = (1.0 - math.Exp(-corrTerm)) / corrTerm
	fChi = 1.0 - (1.0-fChi)*scen.ContMult

	bremI = 0.02 * (scen.Sr * scen.MA * co.bremC * co.zFlt * math.Pow(Uo-1.0, co.bremX))
	contI = bremI * fChi
	return contI
}

func calculateCharEi(k int, p int, co *SourceConst, scen *Scenario, prop *Properties) float64 {
	var tauAtEi, shell, keVedge, fYield, pTrans, Uo, lnUo, rhozbar, corrTerm, fChi float64
	var invStopPow, backScatter, charI float64

	tauAtEi = prop.Tau[k][co.zInt+1]
	shell = prop.Rh[p][0]
	keVedge = prop.Rh[p][2]
	fYield = prop.Rh[p][3]
	pTrans = prop.Rh[p][4]

	Uo = scen.KeVsrc / keVedge
	lnUo = math.Log(Uo)
	rhozbar = (co.rhozmTerm * co.rhozbarTerm * lnUo) / (0.70256 - 1.09865*co.nTerm + 1.0046*math.Pow(co.nTerm, 2.0) + lnUo)
	corrTerm = 2.0 * tauAtEi * rhozbar * co.angleTerm
	fChi = (1.0 - math.Exp(-corrTerm)) / corrTerm
	fChi = 1.0 - (1.0-fChi)*scen.ContMult

	invStopPow = 1.0 + 16.05*math.Sqrt(co.JTerm/keVedge)*((math.Sqrt(Uo)*lnUo+2.0*(1.0-math.Sqrt(Uo)))/(Uo*lnUo+1.0-Uo))
	invStopPow = (1.0 / co.zFlt) * (Uo*lnUo + 1.0 - Uo) * invStopPow
	backScatter = 1 - 0.0081517*co.zFlt + 3.613*math.Pow(10.0, -5.0)*math.Pow(co.zFlt, 2.0) + 0.009583*co.zFlt*math.Exp(-Uo) + 0.001141*scen.KeVsrc

	charI = scen.Sr * scen.MA * invStopPow * backScatter * fYield * pTrans * fChi
	if shell == 1.0 {
		charI = (2.0 * 0.35 * 5.0 * math.Pow(10.0, 13.0)) * charI
	} else {
		charI = (8.0 * 0.25 * 6.9 * math.Pow(10.0, 13.0)) * charI
	}
	charI = charI * scen.CharMult
	return charI
}

func matchEi(keVi float64, keVpeak float64) bool {
	var match bool
	var eVi, eVpeak int

	match = false
	eVi = (int)(keVi * 100)
	eVpeak = (int)(keVpeak * 100)
	if (eVpeak % 2) != 0 {
		eVpeak = eVpeak + 1
	}
	if eVi == eVpeak {
		match = true
	}
	return match
}
