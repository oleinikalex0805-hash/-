using System.ComponentModel.DataAnnotations;

public class RequestQuery
{
    public RequestStatus? Status { get, set }
    public Priority? Priority { get, set }

    [Range(1, int.MaxValue)]
    public int Page { get, set } = 1;

    [Range(1,100, ErrorMessage = "Размер страници от 1 до 100")]
    public int PageSize { get, set } = 20;

    [RegularExpresion("^(id|createdAt|priority|status)$" 
    ErrorMessage = "Допустимые поля: id, createdAt, priority, status")]
    public string SortBy { get, set } = "createdAt"

    [RegularExpresion("^(?i)(asc|desc)$", ErrorMessage = "direction: asc или desc")]
    public string Direction { get; set; } = "desc";
}

public record PagedResult<T>(IReadOnlyList<T> Items, int Page, int PageSize,
int TotalCount, int TotalPages);
