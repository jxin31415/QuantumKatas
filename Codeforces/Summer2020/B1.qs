namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;

    operation Solve (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        using(counter = Qubit[4]){
           
            within{
                for(q in inputs){
                    Controlled Increment([q], LittleEndian(counter));
                }
            } apply {
                (ControlledOnInt(Length(inputs)/2, X))(counter, output);
            }
        }
    }

    operation Increment (register : LittleEndian) : Unit is Adj+Ctl {
        // unwrap LittleEndian type
        let qarray = register!;
        if (Length(qarray) > 1) {
            // increment the rest of the number if the least significant bit is 1
            (Controlled Increment)([qarray[0]], LittleEndian(qarray[1 ...]));
        }
        // increment the least significant bit
        X(qarray[0]);
    }

}