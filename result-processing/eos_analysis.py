import csv
from ase import eos
from ase.units import Bohr, Rydberg
import numpy as np


def main():
    # molecules = ["Ge", "C", "Si", "SiC", "LiCl"]
    molecules = ["LiCl"]
    print("Material,Lattice(Angstorm),Energy(eV),BulkModulus(GPa)")
    for molecule in molecules:
        molecule_to_graph(molecule)


def molecule_to_graph(molecule: str):
    # data_file_dir = f"input_pw/{molecule}"
    data_file_dir = "result"
    with open(f"{data_file_dir}/{molecule}.dat") as csv_file:
        csv_reader = csv.DictReader(csv_file, delimiter="\t")
        data = np.array(
            [[float(row["volume"])*(Bohr**3), float(row["energy"])*Rydberg]
             for row in csv_reader]
        )
        eq_of_state = eos.EquationOfState(data[:, 0], data[:, 1])
        v0, e0, bulk_mod = eq_of_state.fit()
        print(
            f"{molecule},{(v0*4)**(1/3)},{e0},{bulk_mod/eos.kJ * 1.0e24}")
        eq_of_state.plot(
            show=True, filename=f"{data_file_dir}/{molecule}_sjeos_fit.svg")


def fit_sjeos(v, e):
    fit0 = np.poly1d(np.polyfit(v**-(1 / 3), e, 3))
    fit1 = np.polyder(fit0, 1)
    fit2 = np.polyder(fit1, 1)

    v0 = None
    for t in np.roots(fit1):
        if isinstance(t, float) and t > 0 and fit2(t) > 0:
            v0 = t**-3
            break

    if v0 is None:
        raise ValueError('No minimum!')

    e0 = fit0(t)
    B = t**5 * fit2(t) / 9
    fit0 = fit0

    return v0, e0, B


if __name__ == "__main__":
    main()
