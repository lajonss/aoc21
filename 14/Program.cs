Console.WriteLine(GetMaxMinDiff(Apply(GetParsedInput(), ApplyRules, 10).Item1));

T Apply<T>(T obj, Func<T,T> func, int times)
    => times == 0
        ? obj
        : Apply(func(obj), func, times - 1);

int GetMaxMinDiff(string template)
    => ComputeMaxMinDiff(GetGroups(template));

int ComputeMaxMinDiff(IEnumerable<int> counts)
    => counts.Max() - counts.Min();

IEnumerable<int> GetGroups(string template)
    => template.GroupBy(x => x).Select(g => g.Count());

(string, Dictionary<string, string>) ApplyRules((string template, Dictionary<string,string> rules) d)
    => ApplyRulesBetween(d.template.Substring(0, 1), d.template.Substring(1), d.rules);

(string, Dictionary<string, string>) ApplyRulesBetween(string part1, string part2, Dictionary<string, string> rules)
    => string.IsNullOrEmpty(part2)
        ? (part1, rules)
        : ApplyRulesBetween(
            part1
                + GetOrEmpty(rules, part1.Substring(part1.Length - 1) + part2.Substring(0, 1))
                + part2.Substring(0, 1),
            part2.Substring(1),
            rules
        );

Dictionary<string, string> ParseInsertionRules(IEnumerable<string> input)
    => input.Where(line => !string.IsNullOrEmpty(line))
            .Select(line => line.Split(" -> "))
            .ToDictionary(split => split[0], split => split[1]);

string GetOrEmpty(Dictionary<string, string> rules, string key)
    => rules.TryGetValue(key, out var value) ? value : string.Empty;

(string, Dictionary<string, string>) GetParsedInput()
    => ParseInput(GetEnumeratedInput());

(string, Dictionary<string, string>) ParseInput(IEnumerable<string> input)
    => (input.First(), ParseInsertionRules(input.Skip(2)));

IEnumerable<string> GetEnumeratedInput()
    => Console.In.ReadToEnd().Split("\n");
