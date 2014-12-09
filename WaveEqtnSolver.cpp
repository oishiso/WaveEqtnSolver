#include "SC_PlugIn.h"
#include <math.h>
#define kMaxArraySize 100

//  Created by So Oishi on 8/12/14.


// BASIC ADMINISTRATION

static InterfaceTable *ft;

struct WaveEqtnSolver : public Unit
{
    int number;
    float displacement[kMaxArraySize];
    float velocity[kMaxArraySize];
    float acceleration[kMaxArraySize];
};

// declare unit generator functions
extern "C"
{
    void WaveEqtnSolver_Ctor(WaveEqtnSolver *unit);
    void WaveEqtnSolver_next(WaveEqtnSolver *unit, int inNumSamples);
};

//////////////////////////////////////////////////////////////////

// CONSTRUCTOR

void WaveEqtnSolver_Ctor(WaveEqtnSolver *unit)
{
    
    SETCALC(WaveEqtnSolver_next);
    
    unit->number = ZIN0(0);
    for(int i=0;i<kMaxArraySize;i++){
        unit->displacement[i] = 0;
        unit->velocity[i] = 0;
        unit->acceleration[i] = 0;
    };
    
    int pluckPoint = ZIN0(1);
    int pluckWidth = ZIN0(2);
    
    for(int i=pluckPoint-pluckWidth/2;i<pluckPoint+pluckWidth/2;i++){
        unit->displacement[i]= sin(pi_f*(i-(pluckPoint-pluckWidth/2))/pluckWidth);
    };
    
    WaveEqtnSolver_next(unit, 1);
}

//////////////////////////////////////////////////////////////////

// UGEN CALCULATION

void WaveEqtnSolver_next(WaveEqtnSolver *unit, int inNumSamples)
{
    // get the pointer to the output buffer
    float *out = ZOUT(0);
    
    int number = unit->number;
    float displacement[number];
    float velocity[number];
    float acceleration[number];
    
    for (int i=0;i<number;i++){
        displacement[i] = unit->displacement[i];
        velocity[i] = unit->velocity[i];
        acceleration[i] = unit->acceleration[i];
    };
    
    float oneMass = ZIN0(3);
    float totalMass = oneMass*number;
    float lengthString = ZIN0(4);
    float massDistance = lengthString / (number - 1);
    float oneStiffness = ZIN0(5);
    int outputPoint = ZIN0(6);
    float totalStiffness = oneStiffness * number;
    float outval;
    
    LOOP(inNumSamples,
         
         acceleration[0] = totalStiffness*pow(lengthString, 2)/totalMass*(displacement[0]-displacement[1])/pow(massDistance, 2);
         for (int i=1;i<number-1;i++){
             acceleration[i]=totalStiffness*pow(lengthString, 2)/totalMass*(displacement[i-1]-2*displacement[i]+displacement[i+1])/pow(massDistance, 2);
         };
         acceleration[number-1] = totalStiffness*pow(lengthString, 2)/totalMass*(displacement[number-1]-displacement[number-2])/pow(massDistance, 2);
         
         for (int i=1;i<number-1;i++){
             velocity[i] = velocity[i] + acceleration[i] / SAMPLERATE;
             displacement[i] = displacement[i] + velocity[i] / SAMPLERATE;
             outval = displacement[outputPoint];
         };
         ZXP(out) = outval;
         )
    for (int i=0;i<number;i++){
        unit->displacement[i] = displacement[i];
        unit->velocity[i] = velocity[i];
        unit->acceleration[i] = acceleration[i];
    };
}

////////////////////////////////////////////////////////////////////

// LOAD FUNCTION

// the load function is called by the host when the plugin is loaded

PluginLoad(WaveEqtnSolver)
{
    ft = inTable;
    
    DefineSimpleUnit(WaveEqtnSolver);
}

////////////////////////////////////////////////////////////////////

