package fpSimulation

import "dataIO"

func GetProperties() (*Properties, error) {
	properties := new(Properties)
	tau, err := dataIO.ReadCSVtoFloat("./static/data/tau.csv", 1, 0)
	if err != nil {
		return nil, err
	}
	mu, err := dataIO.ReadCSVtoFloat("./static/data/mu.csv", 1, 0)
	if err != nil {
		return nil, err
	}
	rh, err := dataIO.ReadCSVtoFloat("./static/data/rhodium.csv", 1, 1)
	if err != nil {
		return nil, err
	}
	char, err := dataIO.ReadCSVtoFloat("./static/data/characteristics.csv", 1, 1)
	if err != nil {
		return nil, err
	}
	properties.Tau = tau
	properties.Mu = mu
	properties.Rh = rh
	properties.Char = char
	return properties, nil
}
