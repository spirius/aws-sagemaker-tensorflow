# AWS Sagemaker Tensorflow Container - without FMA

Default tensorflow distribution is compiled with FMA support, but FMA
instructions are not supported on VirtualBox. Therfore it is impossible to running sagemaker tensorflow containers when using docker-machine.

Following docker image builds tansorflow with `-march=-no-fma` flag and
reinstalls tensorflow in AWS provided container.

| Official Image | No FMA image |
|----------------|--------------|
| `sagemaker-tensorflow-scriptmode:1.12.0-cpu-py3` | `spirius/sagemaker-tensorflow-scriptmode:1.12.0-cpu-nofma-py3` |

### Example
```python
import sagemaker
from sagemaker.tensorflow import TensorFlow

estimator = TensorFlow(
    entry_point='train.py',
    source_dir='code',
    model_dir='model',
    train_instance_type='local',
    train_instance_count=1,
    role=sagemaker.get_execution_role(),
    script_mode=True,
    image_name='spirius/sagemaker-tensorflow-scriptmode:1.12.0-cpu-nofma-py3',
)
```
