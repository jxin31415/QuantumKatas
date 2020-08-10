// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.GraphColoring {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Graph coloring" quantum kata is a series of exercises designed
    // to teach you the basics of using Grover search to solve constraint
    // satisfaction problems, using graph coloring problem as an example.
    // It covers the following topics:
    //  - writing oracles implementing constraints on graph coloring,
    //  - using Grover's algorithm to solve graph coloring problems with unknown number of solutions.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // Within each section, tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.


    //////////////////////////////////////////////////////////////////
    // Part I. Colors representation and manipulation
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Initialize register to a color
    // Inputs:
    //      1) An integer C (0 ≤ C ≤ 2ᴺ - 1).
    //      2) An array of N qubits in the |0...0⟩ state.
    // Goal: Prepare the array in the basis state which represents the binary notation of C.
    //       Use little-endian encoding (i.e., the least significant bit should be stored in the first qubit).
    // Example: for N = 2 and C = 2 the state should be |01⟩.
    operation InitializeColor (C : Int, register : Qubit[]) : Unit is Adj {
        let b = IntAsBoolArray(C, Length(register));
        for(i in 0..Length(register)-1){
            if(b[i]){
                X(register[i]);
            }
        }
    }


    // Task 1.2. Read color from a register
    // Input: An array of N qubits which are guaranteed to be in one of the 2ᴺ basis states.
    // Output: An N-bit integer that represents this basis state, in little-endian encoding.
    //         The operation should not change the state of the qubits.
    // Example: for N = 2 and the qubits in the state |01⟩ return 2 (and keep the qubits in |01⟩).
    operation MeasureColor (register : Qubit[]) : Int {
        
        mutable b = new Bool[Length(register)];

        for(i in 0..Length(b)-1){
            set b w/= i <- M(register[i]) == One;
        }
        return BoolArrayAsInt(b);
    }


    // Task 1.3. Read coloring from a register
    // Inputs: 
    //      1) The number of elements in the coloring K.
    //      2) An array of K * N qubits which are guaranteed to be in one of the 2ᴷᴺ basis states.
    // Output: An array of K N-bit integers that represent this basis state. 
    //         Integer i of the array is stored in qubits i * N, i * N + 1, ..., i * N + N - 1 in little-endian format.
    //         The operation should not change the state of the qubits.
    // Example: for N = 2, K = 2 and the qubits in the state |0110⟩ return [2, 1].
    operation MeasureColoring (K : Int, register : Qubit[]) : Int[] {
        mutable arr = new Int[K];
        let N = Length(register) / K;
        for(i in 0..K-1){
            set arr w/= i <- MeasureColor(register[i * N .. i * N + N - 1]);
        }
        return arr;
    }


    // Task 1.4. 2-bit color equality oracle
    // Inputs:
    //      1) an array of 2 qubits in an arbitrary state |c₀⟩ representing the first color,
    //      1) an array of 2 qubits in an arbitrary state |c₁⟩ representing the second color,
    //      3) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Transform state |c₀⟩|c₁⟩|y⟩ into state |c₀⟩|c₁⟩|y ⊕ f(c₀, c₁)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if c₀ and c₁ are in the same state, and 0 otherwise.
    //       Leave the query register in the same state it started in.
    // In this task you are allowed to allocate extra qubits.
    operation ColorEqualityOracle_2bit (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        ColorEqualityOracle_Nbit(c0, c1, target);
    }


    // Task 1.5. N-bit color equality oracle (no extra qubits)
    // This task is the same as task 1.4, but in this task you are NOT allowed to allocate extra qubits.
    operation ColorEqualityOracle_Nbit (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        for(i in 0..Length(c0) - 1){
            CNOT(c0[i], c1[i]);
        }

        (ControlledOnInt(0, X))(c1, target);

        for(i in 0..Length(c0) - 1){
            CNOT(c0[i], c1[i]);
        }
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Vertex coloring problem
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Classical verification of vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of V integers, representing the vertex coloring of the graph.
    //         i-th element of the array is the color of the vertex number i.
    // Output: true if the given vertex coloring is valid 
    //         (i.e., no pair of vertices connected by an edge have the same color),
    //         and false otherwise.
    // Example: Graph 0 -- 1 -- 2 would have V = 3 and edges = [(0, 1), (1, 2)].
    //         Some of the valid colorings for it would be [0, 1, 0] and [-1, 5, 18].
    function IsVertexColoringValid (V : Int, edges: (Int, Int)[], colors: Int[]) : Bool {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(colors) == V, $"The vertex coloring must contain exactly {V} elements, and it contained {Length(colors)}.");

        for((u, v) in edges){
            if(colors[u] == colors[v]){
                return false;
            }
        }

        return true;
    }


    // Task 2.2. Oracle for verifying vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of 2V qubits colorsRegister that encodes the color assignments.
    //      4) A qubit in an arbitrary state |y⟩ (target qubit).
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the given vertex coloring is valid and 0 otherwise.
    //       Leave the query register in the same state it started in.
    //
    // Each color in colorsRegister is represented as a 2-bit integer in little-endian format.
    // See task 1.3 for a more detailed description of color assignments.
    operation VertexColoringOracle (V : Int, edges : (Int, Int)[], colorsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        using(q = Qubit[Length(edges)]){
            for(i in 0.. Length(edges)-1){
                let (u, v) = edges[i];
                ColorEqualityOracle_Nbit(colorsRegister[u * 2 .. u * 2 + 1], colorsRegister[v * 2 .. v * 2 + 1], q[i]);
            }

            (ControlledOnInt(0, X))(q, target);
            
            for(i in 0.. Length(edges) - 1){
                let (u, v) = edges[i];
                ColorEqualityOracle_Nbit(colorsRegister[u * 2 .. u * 2 + 1], colorsRegister[v * 2 .. v * 2 + 1], q[i]);
            }
        }
    }


    // Task 2.3. Using Grover's search to find vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) A marking oracle which implements vertex coloring verification, as implemented in task 2.2.
    //
    // Output: A valid vertex coloring for the graph, in a format used in task 2.1.
    operation GroversAlgorithm (V : Int, oracle : ((Qubit[], Qubit) => Unit is Adj)) : Int[] {
        
        mutable answer = new Int[V];

        using((register, output) = (Qubit[2 * V], Qubit())){
            mutable iter = 1;
            mutable success = false;

            repeat {
                ApplyToEach(H, register);
                // Set-up
                X(output);
                H(output); // puts the output qubit in a |-⟩ state
                // Run Grover iterations

                for(i in 1..iter){
                    oracle(register, output);
                    ApplyToEach(H, register);
                    (ControlledOnInt(0, X))(register, output);
                    ApplyToEach(H, register);
                }

                // Measure
                let res = MultiM(register);
                Reset(output);
                oracle(register, output);
                if(MResetZ(output) == One){
                    set success = true;
                    for(i in 0..V-1){
                        set answer w/= i <- ResultArrayAsInt([res[2*i + 1], res[2*i]]);
                    }
                }

                ResetAll(register);
                set iter += 1;
            } until (success or iter > 10);
            if(not success){
                Message($"{answer}");
            }
        }

        return answer;
    }
}