namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        mutable iter = 1;
        mutable ans = 0;
        using(q = Qubit()){
            repeat {
                for(i in 1..iter){
                    unitary(q);
                }
                if(M(q) == One){
                    set ans = 1;
                }
                Reset(q);
                set iter += 1;
            } until (iter > 50 or ans == 1);
        }
        return ans;
    }
}
