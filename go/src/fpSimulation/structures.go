package fpSimulation

type Properties struct {
	Tau, Mu, Rh, Char [][]float64
}

type Scenario struct {
	Error bool `json:"error"`
	MaxZ  int  `json:"-"`

	KeVsrc   float64     `json:"-"`
	MA       float64     `json:"-"`
	Sr       float64     `json:"-"`
	ThetaIn  float64     `json:"-"`
	ThetaOut float64     `json:"-"`
	ContMult float64     `json:"-"`
	CharMult float64     `json:"-"`
	SrcI     [][]float64 `json:"-"`

	BeamPath [][]float64 `json:"-"`
	BeamI    [][]float64 `json:"BeamI"`

	GeomFactor float64     `json:"-"`
	Sample     [][]float64 `json:"-"`
	MuSample   [][]float64 `json:"-"`
	PeaksI     [][]float64 `json:"-"`

	DetectorPath [][]float64 `json:"-"`
	DetectorI    [][]float64 `json:"DetectorI"`

	NoiseM    float64     `json:"-"`
	NoiseB    float64     `json:"-"`
	SpectrumI [][]float64 `json:"SpectrumI"`
}

type SourceConst struct {
	zInt        int
	zFlt        float64
	bremC       float64
	bremX       float64
	angleTerm   float64
	ATerm       float64
	mTerm       float64
	JTerm       float64
	nTerm       float64
	rhozmTerm   float64
	rhozbarTerm float64
}
