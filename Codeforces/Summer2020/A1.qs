namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        using(register = Qubit[2]){
            X(register[0]);
            unitary(register);
            if(M(register[1]) == One){
                ResetAll(register);
                return 0;
            } else {
                ResetAll(register);
                return 1;
            }
        }
    }
}