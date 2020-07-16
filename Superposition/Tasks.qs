// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Superposition {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Superposition" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - basic single-qubit and multi-qubit gates,
    //  - superposition,
    //  - flow control and recursion in Q#.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.

    //////////////////////////////////////////////////////////////////
    // Part I. Simple Gates
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Plus state
    // Input: a qubit in the |0⟩ state.
    // Goal: prepare a |+⟩ state on this qubit (|+⟩ = (|0⟩ + |1⟩) / sqrt(2)).
    operation PlusState (q : Qubit) : Unit {
        // Hadamard gate H will convert |0⟩ state to |+⟩ state.
        // Type the following: H(q);
        // Then rebuild the project and rerun the tests - T01_PlusState_Test should now pass!
        H(q);
    }


    // Task 1.2. Minus state
    // Input: a qubit in the |0⟩ state.
    // Goal: prepare a |-⟩ state on this qubit (|-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    operation MinusState (q : Qubit) : Unit {
        // In this task, as well as in all subsequent ones, you have to come up with the solution yourself.
        H(q);
        Z(q);
    }


    // Task 1.3. Superposition of all basis vectors on two qubits
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal:  create the following state on these qubits: (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2.
    operation AllBasisVectors_TwoQubits (qs : Qubit[]) : Unit {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(qs) == 2, "The array should have exactly 2 qubits.");
        H(qs[0]);
        H(qs[1]);
    }


    // Task 1.4. Superposition of basis vectors with phase flip.
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal:  create the following state on these qubits: (|00⟩ + |01⟩ + |10⟩ - |11⟩) / 2.
    operation AllBasisVectorWithPhaseFlip_TwoQubits (qs : Qubit[]) : Unit {
        H(qs[0]);
        H(qs[1]);
        Controlled Z([qs[0]], qs[1]);
    }


    // Task 1.5. Superposition of basis vectors with phases
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal:  create the following state on these qubits: (|00⟩ + i*|01⟩ - |10⟩ - i*|11⟩) / 2.
    operation AllBasisVectorsWithPhases_TwoQubits (qs : Qubit[]) : Unit {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(qs) == 2, "The array should have exactly 2 qubits.");
        H(qs[0]);
        H(qs[1]);
        Z(qs[0]);
        S(qs[1]);
    }


    // Task 1.6. Bell state
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation BellState (qs : Qubit[]) : Unit {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }


    // Task 1.7. All Bell states
    // Inputs:
    //      1) two qubits in |00⟩ state (stored in an array of length 2)
    //      2) an integer index
    // Goal: create one of the Bell states based on the value of index:
    //       0: |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    //       1: |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    //       2: |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    //       3: |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    operation AllBellStates (qs : Qubit[], index : Int) : Unit {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
        if(index != 0){
            if(index == 2){
                X(qs[1]);
            } else {
                Z(qs[1]);
                if(index == 3){
                    X(qs[1]);
                }
            }
        }
    }


    // Task 1.8. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0⟩ state.
    // Goal: create a GHZ state (|0...0⟩ + |1...1⟩) / sqrt(2) on these qubits.
    operation GHZ_State (qs : Qubit[]) : Unit {
        // Hint: N can be found as Length(qs).
        H(qs[0]);
        for(index in 1..Length(qs)-1){
            CNOT(qs[index-1], qs[index]);
        }
    }


    // Task 1.9. Superposition of all basis vectors
    // Input: N qubits in |0...0⟩ state.
    // Goal: create an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩
    // (i.e. state (|0...0⟩ + ... + |1...1⟩) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs);
    }


    // Task 1.10. Superposition of all even or all odd numbers
    // Inputs:
    //      1) N qubits in |0...0⟩ state.
    //      2) A boolean isEven.
    // Goal: create a superposition of all even numbers on N qubits if isEven is true,
    //       or a superposition of all odd numbers on N qubits if isEven is false.
    // 
    // A basis state encodes an integer number using big-endian binary notation: 
    // state |01⟩ corresponds to the integer 1, and state |10⟩ - to the integer 2. 
    //
    // Example: for N = 2 and isEven = true the required state is (|00⟩ + |10⟩) / sqrt(2), 
    //      and for N = 2 and isEven = false - (|01⟩ + |11⟩) / sqrt(2).
    operation EvenOddNumbersSuperposition (qs : Qubit[], isEven : Bool) : Unit {
        for(index in 0..Length(qs)-2){
            H(qs[index]);
        }
        if(isEven){
            // keep last bit as 0
        } else {
            X(qs[Length(qs)-1]);
        }
    }
    

    // Task 1.11. Superposition of |0...0⟩ and given bit string
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) bit string represented as Bool[]
    // Goal: create an equal superposition of |0...0⟩ and basis state given by the bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // You are guaranteed that the qubit array and the bit string have the same length.
    // You are guaranteed that the first bit of the bit string is true.
    // Example: for bit string = [true, false] the qubit state required is (|00⟩ + |10⟩) / sqrt(2).
    operation ZeroAndBitstringSuperposition (qs : Qubit[], bits : Bool[]) : Unit {
        Fact(Length(bits) == Length(qs), "Arrays should have the same length");
        Fact(Head(bits), "First bit of the input bit string should be set to true");

        H(qs[0]);
        for(index in 1..Length(bits) - 1){
            if(bits[index]){
                Controlled X([qs[0]], qs[index]);
            }
        }
    }


    // Task 1.12. Superposition of two bit strings
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) two bit string represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bit strings.
    //
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // Example: for bit strings [false, true, false] and [false, false, true]
    // the qubit state required is (|010⟩ + |001⟩) / sqrt(2).
    // You are guaranteed that the both bit strings have the same length as the qubit array,
    // and that the bit strings will differ in at least one bit.
    operation TwoBitstringSuperposition (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Unit {
        mutable diff = -1;

        repeat {
            set diff = diff + 1;
        } until (bits1[diff] != bits2[diff]);

        H(qs[diff]);

        for(index in 0..diff-1){
            if(bits1[index] and bits2[index]){
                X(qs[index]);
            }
        }
        for(index in diff+1..Length(qs)-1){
            if(bits1[index] == false and bits2[index] == false){
                //do nothing
            } else {
                if (bits1[index] and bits2[index]){
                    X(qs[index]);
                } else {
                    CNOT(qs[diff], qs[index]);
                    if(bits1[index] != bits1[diff]){
                        X(qs[index]);
                    }
                }
            }
        }

        // Option #2
        // using (q = Qubit()) {
        // H(q);
        
        // for (i in 0 .. Length(qs) - 1) {
        //     if (bits1[i]) {
        //         (ControlledOnInt(0, X))([q], qs[i]);
        //     }
        //     if (bits2[i]) {
        //         (ControlledOnInt(1, X))([q], qs[i]);
        //     }
        // }
        
        // // uncompute the auxiliary qubit to release it
        // (ControlledOnBitString(bits2, X))(qs, q);
    }


    // Task 1.13*. Superposition of four bit strings
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) four bit string represented as Bool[][] bits
    //         bits is an array of size 4 x N array which describes the bit strings as follows:
    //         bits[i] describes the i-th bit string and has N elements.
    //         All four bit strings will be distinct.
    //
    // Goal: create an equal superposition of the four basis states given by the bit strings.
    //
    // Example: for N = 3 and bits = [[false, true, false], [true, false, false], [false, false, true], [true, true, false]]
    //          the state you need to prepare is (|010⟩ + |100⟩ + |001⟩ + |110⟩) / 2.
    operation FourBitstringSuperposition (qs : Qubit[], bits : Bool[][]) : Unit {
        // Hint: remember that you can allocate extra qubits.
        using (q = Qubit()) {
            using(q2 = Qubit()){
                H(q);
                H(q2);

                for(i in 0..Length(qs)-1){
                    if (bits[0][i]) {
                        (ControlledOnInt(0, X))([q, q2], qs[i]);
                    }
                    if(bits[1][i]){
                        (ControlledOnInt(1, X))([q, q2], qs[i]);
                    }
                    if(bits[2][i]){
                        (ControlledOnInt(2, X))([q, q2], qs[i]);
                    }
                    if(bits[3][i]){
                        (ControlledOnInt(3, X))([q, q2], qs[i]);
                    }
                }

                // OPPOSITE OF EXPECTED B/C ITS LITTLE ENDIAN
                (ControlledOnBitString(bits[1], X))(qs, q);
                (ControlledOnBitString(bits[2], X))(qs, q2);
                (ControlledOnBitString(bits[3], X))(qs, q);
                (ControlledOnBitString(bits[3], X))(qs, q2);

            }
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Arbitrary Rotations
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Unequal superposition
    // Inputs:
    //      1) a qubit in the |0⟩ state.
    //      2) angle alpha, in radians, represented as Double.
    // Goal: prepare a cos(alpha) * |0⟩ + sin(alpha) * |1⟩ state on this qubit.
    operation UnequalSuperposition (q : Qubit, alpha : Double) : Unit {
        // Hint: Experiment with rotation gates from the Microsoft.Quantum.Intrinsic namespace.
        // Note that all rotation operators rotate the state by _half_ of its angle argument.
        Ry(alpha * 2.0, q);
    }


    // Task 2.2. 1/sqrt(2)|00⟩ + 1/2|01⟩ + 1/2|10⟩ state
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: change the state to 1/sqrt(2)|00⟩ + 1/2|10⟩ + 1/2|11⟩.
    operation ControlledRotation (qs : Qubit[]) : Unit {
        H(qs[0]);
        Controlled H([qs[0]], qs[1]);
    }

    // Task 2.3*. |00⟩ + |01⟩ + |10⟩ state
    // Input: 2 qubits in |00⟩ state (stored in an array of length 2).
    // Goal: change the state to (|00⟩ + |01⟩ + |10⟩) / sqrt(3).
    operation ThreeStates_TwoQubits (qs : Qubit[]) : Unit {
        // let theta = ArcTan(1.0 / Sqrt(2.0));
        // Ry(theta * 2.0, qs[0]);
        // (ControlledOnInt(0, H))([qs[0]], qs[1]);
        

        //Alternative method with measurement
        using(q = Qubit()){
            repeat {
                ResetAll(qs);
                H(qs[0]);
                H(qs[1]);
                CCNOT(qs[0], qs[1], q);
            } until (MResetZ(q) == Zero);
        }
    }


    // Task 2.4*. (|00⟩ + ω |01⟩ + ω² |10⟩) / sqrt(3)
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: change the state to (|00⟩ + ω |01⟩ + ω² |10⟩) / sqrt(3) where ω is exp(2πi/3).
    operation ThreeStates_TwoQubits_Phases (qs : Qubit[]) : Unit {
        let theta = ArcTan(1.0 / Sqrt(2.0));
        Ry(theta * 2.0, qs[0]);
        (ControlledOnInt(0, H))([qs[0]], qs[1]);

        R1(4.0 * PI() / 3.0, qs[0]);
        R1(2.0 * PI() / 3.0, qs[1]);
    }


    // Task 2.5*. Hardy State
    // Input: 2 qubits in |00⟩ state.
    // Goal: create the state (3|00⟩ + |01⟩ + |10⟩ + |11⟩) / sqrt(12) on these qubits.
    operation Hardy_State (qs : Qubit[]) : Unit {
        let theta = ArcTan(1.0 / Sqrt(5.0));

        Ry(theta * 2.0, qs[0]);

        let thetaZ = ArcTan(1.0 / 3.0);
        (ControlledOnInt(0, Ry))([qs[0]], (thetaZ * 2.0, qs[1]));

        Controlled H([qs[0]], qs[1]);
    }


    // Task 2.6*. W state on 2ᵏ qubits
    // Input: N = 2ᵏ qubits in |0...0⟩ state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000⟩ + |0100⟩ + |0010⟩ + |0001⟩) / 2.
    operation WState_PowerOfTwo (qs : Qubit[]) : Unit {
        // Hint: you can use Controlled modifier to perform arbitrary controlled gates.
        
        mutable increment = Length(qs);
        for(index in 0..Length(qs)-1){
            if(index == Length(qs)-1){
                using(q = Qubit()){
                    (ControlledOnInt(0, X))(qs, q);
                    CNOT(q, qs[Length(qs)-1]);
                    (ControlledOnInt(0, X))(qs, q);
                    (ControlledOnInt(2 ^ (index), X))(qs, q);
                }
            } else {
                using(q = Qubit()){
                    (ControlledOnInt(0, X))(qs, q);
                    let theta = ArcTan(Sqrt(1.0/ IntAsDouble(increment)) / Sqrt(1.0 - 1.0/IntAsDouble(increment)));
                    Controlled Ry([q], (2.0 * theta, qs[index]));
                    (ControlledOnInt(0, X))(qs, q);
                    (ControlledOnInt(2 ^ (index), X))(qs, q);
                }
            }
            set increment = increment - 1;
        }
    }


    // Task 2.7**. W state on arbitrary number of qubits
    // Input: N qubits in |0...0⟩ state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100⟩ + |010⟩ + |001⟩) / sqrt(3).
    operation WState_Arbitrary (qs : Qubit[]) : Unit { // : Unit is Adj+Ctl allows you to call Controlled WState_Arbitrary
        
        let N = Length(qs);
        for(index in 0..Length(qs)-1){
            if(index == Length(qs)-1){
                using(q = Qubit()){
                    (ControlledOnInt(0, X))(qs, q);
                    CNOT(q, qs[Length(qs)-1]);
                    (ControlledOnInt(0, X))(qs, q);
                    (ControlledOnInt(2 ^ (index), X))(qs, q);
                }
            } else {
                using(q = Qubit()){
                    (ControlledOnInt(0, X))(qs, q);
                    let theta = ArcTan(Sqrt(1.0/ IntAsDouble(N - index)) / Sqrt(1.0 - 1.0/IntAsDouble(N - index)));
                    Controlled Ry([q], (2.0 * theta, qs[index]));
                    (ControlledOnInt(0, X))(qs, q);
                    (ControlledOnInt(2 ^ (index), X))(qs, q);
                }
            }
        }

        // Simplified to use a range in an array --> qs[0.. i]
        // let N = Length(qs);
        // Ry(2.0 * ArcSin(Sqrt(1.0/IntAsDouble(N))), qs[0]);
        // for (i in 1 .. N-1) {
        //     (ControlledOnInt(0, Ry(2.0 * ArcSin(Sqrt(1.0/IntAsDouble(N - i))), _)))(qs[0 .. i-1], qs[i]);
        // }
    }
}
