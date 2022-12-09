#!/usr/bin/env python3
import sys
from yaml import safe_dump
from resoto_plugin_aws.collector import called_collect_apis, called_mutator_apis
from resoto_plugin_aws.resource.base import AwsApiSpec


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: genpolicy.py <template_file>")
        sys.exit(1)
    in_file = sys.argv[1]
    indent_by = 6

    with open(in_file, "r") as f:
        template = f.read()
    if not template.endswith("\n"):
        template += "\n"

    def get_policies() -> None:
        def iam_statement(name: str, apis: list[AwsApiSpec]) -> tuple[set[str], str]:
            permissions = {api.iam_permission() for api in apis}
            statement = {
                "PolicyName": name,
                "PolicyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [{"Effect": "Allow", "Resource": "*", "Action": sorted(permissions)}],
                },
            }
            return statement

        collect_policy = iam_statement("ResotoCollect", called_collect_apis())
        mutate_policy = iam_statement("ResotoMutate", called_mutator_apis())
        policies = [collect_policy, mutate_policy]
        return policies

    policies = safe_dump(get_policies(), sort_keys=False)
    policies = "\n".join(" " * indent_by + line for line in policies.splitlines())
    print(f"{template}{policies}")


if __name__ == "__main__":
    main()
