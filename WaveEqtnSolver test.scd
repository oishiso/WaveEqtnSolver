StageLimiter.activate;

(
~openAnalyzer = {
var window, func;
window = Window("Analyzer", Rect(600, 30, 511, 300)); // width should be 511
func = FreqScopeView(window, window.view.bounds);
func.active_(true); // turn it on the first time;
func.freqMode_(0); //0 = linear scale, 1 = log scale
window.onClose_({ func.kill }); // you must have this
window.front;
}.value
)


(
SynthDef(\testWaveEqtnSolver,
	{arg number = 30,
		pluckPoint = 10,
		pluckWidth = 8,
		oneMassMilligram = 1,
		lengthString = 2.0,
		oneStiffness = 0.01,
		outputPoint = 10,
		mul = 0.5,
		add = 0.0;
		var sound = WaveEqtnSolver.ar(number, pluckPoint, pluckWidth, oneMassMilligram*0.000001, lengthString, oneStiffness, outputPoint, mul, add).poll.scope;
		sound = Pan2.ar(sound, 0);
		Out.ar(0,sound)
}).load
)

(
var window, sound, sl1, sl2, sl3, sl4, sl5, sl6, sl7, sl8;
window = Window("Coupled Resonator", Rect(100,420,620,300));
window.view.decorator = FlowLayout(window.view.bounds);
StaticText(window,620 @ 40).string_("Coupled Resonator").align_(\center)
	.font_(Font("Helvetica", 16));
window.view.decorator.nextLine;
sl1 = EZSlider(window, 600 @ 20, "number", ControlSpec(1,40, step:1, default: 20),
	labelWidth: 140);
window.view.decorator.nextLine;
sl2 = EZSlider(window, 600 @ 20, "pluckPoint", ControlSpec(1,20, step:1, default: 10),
	labelWidth: 140);
window.view.decorator.nextLine;
sl3 = EZSlider(window, 600 @ 20, "pluckWidth", ControlSpec(1,40, step:1, default: 10),
	labelWidth: 140);
window.view.decorator.nextLine;
sl4 = EZSlider(window, 600 @ 20, "oneMassMilligram", ControlSpec(0.001,10,\exponential, default: 1.0),
	 	{| view | if (sound.notNil)
	 			   { sound.set(\oneMassMilligram, view.value)}
	 	},
	labelWidth: 140);
window.view.decorator.nextLine;
sl5 = EZSlider(window, 600 @ 20, "lengthString", ControlSpec(0.1,10, default: 1.0),
	 	{| view | if (sound.notNil)
	 			   { sound.set(\lengthString, view.value)}
	 	},
	labelWidth: 140);
window.view.decorator.nextLine;
sl6 = EZSlider(window, 600 @ 20, "oneStiffness", ControlSpec(0.0001,0.1,\exponential, default: 0.01),
	 	{| view | if (sound.notNil)
	 			   { sound.set(\oneStiffness, view.value)}
	 	},
	labelWidth: 140);
window.view.decorator.nextLine;
sl7 = EZSlider(window, 600 @ 20, "outputPoint", ControlSpec(1,20, step:1, default: 10),
	 	{| view | if (sound.notNil)
	 			   { sound.set(\outputPoint, view.value)}
	 	},
	labelWidth: 140);
window.view.decorator.nextLine;
sl8 = EZSlider(window, 600 @ 20, "Amp", ControlSpec(0,1.0,\amp,default: 0.5),
	 	{| view | if (sound.notNil)
	 			   { sound.set(\mul, view.value)}
	 	},
	labelWidth: 140);
window.view.decorator.left_(400).top_(250);
Button(window, 40@40)
	.states_([["Start"], ["Stop", Color.black, Color.red(alpha: 0.2)]])
	.action_({|view|  if (view.value ==1 && sound.isNil,
	{sound =
		Synth(\testWaveEqtnSolver,
			[\number,sl1.value,
				\pluckPoint,sl2.value,
				\pluckWidth,sl3.value,
				\oneMassMilligram,sl4.value,
				\lengthString,sl5.value,
				\oneStiffness,sl6.value,
				\outputPoint,sl7.value,
				\mul,sl8.value,
	])},
	{sound.free; sound = nil }
	)
});
window.front;
)
