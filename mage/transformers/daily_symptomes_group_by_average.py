from mage_ai.data_cleaner.transformer_actions.base import BaseAction
from mage_ai.data_cleaner.transformer_actions.constants import ActionType, Axis
from mage_ai.data_cleaner.transformer_actions.utils import build_transformer_action
from pandas import DataFrame

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

class GroupByAverageTransformer:
    def __init__(self, group_by_column, value_column):
        self.group_by_column = group_by_column
        self.value_column = value_column
    
    def transform(self, df):
        grouped_df = df.groupby(self.group_by_column)[self.value_column].mean().reset_index()
        return grouped_df

@transformer
def execute_transformer_action(df: DataFrame, *args, **kwargs) -> DataFrame:
    """
    Execute Transformer Action: ActionType.AVERAGE

    Docs: https://docs.mage.ai/guides/transformer-blocks#aggregation-actions
    """
    transformer = GroupByAverageTransformer(group_by_column=['country_region_code', 'country_region'], value_column=df.columns[8:])
    result_df = transformer.transform(df)

    return result_df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
