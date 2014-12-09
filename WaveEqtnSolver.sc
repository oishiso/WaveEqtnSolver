WaveEqtnSolver : PureUGen  {
	*ar { arg number = 20, pluckPoint = 10, pluckWidth = 10, oneMass = 0.000001, lengthString = 1.0, oneStiffness = 0.01, outputPoint = 10, mul = 1.0, add = 0.0;
		^this.multiNew('audio', number, pluckPoint, pluckWidth, oneMass, lengthString, oneStiffness,  outputPoint).madd(mul, add)
	}
	*kr { arg number = 20, pluckPoint = 10, pluckWidth = 10, oneMass = 0.000001, lengthString = 1.0, oneStiffness = 0.01, outputPoint = 10, mul = 1.0, add = 0.0;
		^this.multiNew('control', number, pluckPoint, pluckWidth, oneMass, lengthString, oneStiffness, outputPoint).madd(mul, add)
	}
}