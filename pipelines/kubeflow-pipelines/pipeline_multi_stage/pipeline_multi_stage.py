import kfp, os

custom_comp = kfp.components.load_component_from_file(os.path.join(os.getcwd(), '../../components/custom_component/component.yaml'))

@kfp.dsl.pipeline(name="First custom component Pipeline", description="use custom component with ECR custom docker image")
def my_pipeline(
    pparam1: "one\ntwo\nthree\nfour\nfive\nsix\nseven\neight\nnine\nten"
    ):

    step1 = custom_comp(
        input_1=pparam1,
        parameter_1="5"
    )

    step2 = custom_comp(
        input_1=step1.outputs["output_1"],
        parameter_1="3"
    )

if __name__ == '__main__':
    kfp.compiler.Compiler().compile(my_pipeline, __file__.split(".py")[0] + ".yaml")