namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;

    operation Solve (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        using(counter = Qubit[2]){
            within {
                for(i in 0..Length(inputs)-1){
                    if(i % 2 == 0){
                        Controlled Increment([inputs[i]], counter);
                    } else {
                        Controlled Decrement([inputs[i]], counter);
                    }
                }
            } apply {
                (ControlledOnInt(0, X))(counter, output);
            }
        }
    }

    operation Increment (register : Qubit[]) : Unit is Adj+Ctl { // implement (+1)%3
        (ControlledOnInt(0, X))([register[0]], register[1]);
        (ControlledOnInt(0, X))([register[1]], register[0]);
    }

    operation Decrement (register: Qubit[]) : Unit is Adj+Ctl { // implement (-1)%3
        Adjoint Increment(register);
    }
}
