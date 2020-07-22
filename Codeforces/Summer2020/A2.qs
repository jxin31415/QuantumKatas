namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        mutable ans = -1;
        using(q = Qubit[2]){
            X(q[1]);
            unitary(q);

            let res1 = M(q[0]);
            let res2 = M(q[1]);

            if(res1 == One and res2 == One){
                set ans = 2;
            } elif (res1 == One and res2 == Zero){
                set ans = 3;
            } else {
                ResetAll(q);
                X(q[0]);
                unitary(q);

                let r1 = M(q[0]);
                let r2 = M(q[1]);

                if(r1 == One and r2 == Zero){
                    set ans = 0;
                }
                if(r1 == One and r2 == One){
                    set ans = 1;
                }
            }

            ResetAll(q);
        }

        return ans;
    }
}