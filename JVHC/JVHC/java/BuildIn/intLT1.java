package BuildIn;

import java.util.function.Function;
import java.util.function.Supplier;

public class intLT1 implements Function<Supplier<Integer>,Bool> {
    Supplier<Integer> i0;

    intLT1(Supplier<Integer> i0) {
        this.i0 = i0;
    }


    @Override
    public Bool apply(Supplier<Integer> i1) {
        return i0.get().intValue() < i1.get().intValue() ? new True() : new False();
    }
}