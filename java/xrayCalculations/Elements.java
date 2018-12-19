package fpSimulation;

import java.util.HashMap;

public class Elements {
    HashMap<String, Integer> elementToZ;
    
    public Elements() {
        this.elementToZ = new HashMap<String, Integer>();
        this.elementToZ.put("H",1);
        this.elementToZ.put("He",2);
        this.elementToZ.put("Li",3);
        this.elementToZ.put("Be",4);
        this.elementToZ.put("B",5);
        this.elementToZ.put("C",6);
        this.elementToZ.put("N",7);
        this.elementToZ.put("O",8);
        this.elementToZ.put("F",9);
        this.elementToZ.put("Ne",10);
        this.elementToZ.put("Na",11);
        this.elementToZ.put("Mg",12);
        this.elementToZ.put("Al",13);
        this.elementToZ.put("Si",14);
        this.elementToZ.put("P",15);
        this.elementToZ.put("S",16);
        this.elementToZ.put("Cl",17);
        this.elementToZ.put("Ar",18);
        this.elementToZ.put("K",19);
        this.elementToZ.put("Ca",20);
        this.elementToZ.put("Sc",21);
        this.elementToZ.put("Ti",22);
        this.elementToZ.put("V",23);
        this.elementToZ.put("Cr",24);
        this.elementToZ.put("Mn",25);
        this.elementToZ.put("Fe",26);
        this.elementToZ.put("Co",27);
        this.elementToZ.put("Ni",28);
        this.elementToZ.put("Cu",29);
        this.elementToZ.put("Zn",30);
        this.elementToZ.put("Ga",31);
        this.elementToZ.put("Ge",32);
        this.elementToZ.put("As",33);
        this.elementToZ.put("Se",34);
        this.elementToZ.put("Br",35);
        this.elementToZ.put("Kr",36);
        this.elementToZ.put("Rb",37);
        this.elementToZ.put("Sr",38);
        this.elementToZ.put("Y",39);
        this.elementToZ.put("Zr",40);
        this.elementToZ.put("Nb",41);
        this.elementToZ.put("Mo",42);
        this.elementToZ.put("Tc",43);
        this.elementToZ.put("Ru",44);
        this.elementToZ.put("Rh",45);
        this.elementToZ.put("Pd",46);
        this.elementToZ.put("Ag",47);
        this.elementToZ.put("Cd",48);
        this.elementToZ.put("In",49);
        this.elementToZ.put("Sn",50);
        this.elementToZ.put("Sb",51);
        this.elementToZ.put("Te",52);
        this.elementToZ.put("I",53);
        this.elementToZ.put("Xe",54);
        this.elementToZ.put("Cs",55);
        this.elementToZ.put("Ba",56);
    }
    
    public int getZ(String element) {
        return this.elementToZ.get(element);
    }
}