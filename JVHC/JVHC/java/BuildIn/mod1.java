package BuildIn;

import java.util.function.Function;
import java.util.function.Supplier;

/**
 * Created by joeisaacs on 01/02/2017.
 */
public class mod1 implements Function<Supplier<Integer>,Integer> {
    Supplier<Integer> i0;

    mod1(Supplier<Integer> i0) {
        this.i0 = i0;
    }

    @Override
    public Integer apply(Supplier<Integer> i1) {
        return i0.get() % i1.get();
    }
}