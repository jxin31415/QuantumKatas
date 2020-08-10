namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        mutable ans = 0;
        using(qs = Qubit[2]){
            H(qs[0]);
            CNOT(qs[0], qs[1]);

            unitary(qs[0]);

            CNOT(qs[0], qs[1]);
            H(qs[0]);

            let res1 = M(qs[0]) == One;
            let res2 = M(qs[1]) == One;

            ResetAll(qs);

            if(res1 and res2){
                set ans = 2;
            } elif(res1 and not res2){
                set ans = 3;
            } elif (not res1 and res2){
                set ans = 1;
            }
        }

        return ans;
    }
}
