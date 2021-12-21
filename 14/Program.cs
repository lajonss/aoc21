Console.WriteLine(GetMaxMinDiff(Apply(GetParsedInput(), ApplyRules, 40)));

T Apply<T>(T obj, Func<T,T> func, int times)
    => times == 0
        ? obj
        : Apply(func(obj), func, times - 1);

long GetMaxMinDiff(Data data)
    => ComputeMaxMinDiff(GetGroups(data));

long ComputeMaxMinDiff(IEnumerable<long> counts)
    => counts.Max() - counts.Min();

IEnumerable<long> GetGroups(Data data)
    => data.template
        .Concat(new[] {new KeyValuePair<string, long> (Str(default(char), data.firstChar), 1)})
        .GroupBy(kvp => kvp.Key[1], (key, values) => values.Select(kvp => kvp.Value).Sum());

Data ApplyRules(Data data)
    => new Data {
        firstChar = data.firstChar,
        rules = data.rules,
        template = data.template
            .SelectMany(kvp => ApplyRulesTo(kvp, data.rules))
            .GroupBy(kvp => kvp.Key, (key, values) => new KeyValuePair<string, long>(key, values.Select(kvp => kvp.Value).Sum()))
            .ToDictionary(kvp => kvp.Key, kvp => kvp.Value)
    };

IEnumerable<KeyValuePair<string, long>> ApplyRulesTo(KeyValuePair<string, long> kvp, Dictionary<string, char> rules)
    => rules.TryGetValue(kvp.Key, out var value)
        ? new[] {
            new KeyValuePair<string, long>(Str(kvp.Key[0], value), kvp.Value),
            new KeyValuePair<string, long>(Str(value, kvp.Key[1]), kvp.Value)}
        : new[] {kvp};

Data GetParsedInput()
    => ParseInput(GetEnumeratedInput());

Data ParseInput(IEnumerable<string> input)
    => ParseInputs(input.First(), ParseInsertionRules(input.Skip(2)));

Data ParseInputs(string template, Dictionary<string, char> rules)
    => new Data {
        firstChar = template[0],
        template = ParseTemplate(template),
        rules = rules
    };

Dictionary<string, char> ParseInsertionRules(IEnumerable<string> input)
    => input.Where(line => !string.IsNullOrEmpty(line))
            .Select(line => line.Split(" -> "))
            .ToDictionary(split => split[0], split => split[1][0]);

Dictionary<string, long> ParseTemplate(string template)
    => template.Take(template.Length - 1)
        .Zip(template.Skip(1), (c1, c2) => Str(c1, c2))
        .ToDictionary(s => s, _ => 1L);

IEnumerable<string> GetEnumeratedInput()
    => Console.In.ReadToEnd().Split("\n");

string Str(char a, char b)
    => "" + a + b;

public struct Data {
    public char firstChar;
    public Dictionary<string, long> template;
    public Dictionary<string, char> rules;
}
