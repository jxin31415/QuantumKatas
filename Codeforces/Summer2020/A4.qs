namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation Solve (unitary : ((Double, Qubit) => Unit is Adj+Ctl)) : Int {
        mutable res = -1;
        using((q1, q2) = (Qubit(), Qubit())){
            H(q1);
            H(q2);
            Controlled unitary([q1], (2.0 * PI(), q2));

            H(q1);
            H(q2);

            if(M(q1) == Zero){
                set res = 1;
            } else {
                set res = 0;
            }

            Reset(q1);
            Reset(q2);
        }
        return res;
    }
}