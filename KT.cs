[ApiController]
[Route("api/requests")]
public class RequestsController : ControllerBase
{
private readonly AppDbContext _db;
public RequestsController(AppDbContext db) => _db = db;

[HttpGet]
public async Task<ActionResult<PagedResult<Request>>> Get([FromQuery] RequestQuery q)
{
IQueryable<Request> query = _db.Requests.AsNoTracking();
if (q.Status.HasValue) query = query.Where(r => r.Status == q.Status);
if (q.Priority.HasValue) query = query.Where(r => r.Priority == q.Priority);

bool asc = q.Direction.Equals("asc", StringComparison.OrdinalIgnoreCase);
query = q.SortBy switch
{
"id" => asc ? query.OrderBy(r => r.Id) : query.OrderByDescending(r => r.Id),
"priority" => asc ? query.OrderBy(r => r.Priority) : query.OrderByDescending(r => r.Priority),
"status" => asc ? query.OrderBy(r => r.Status) : query.OrderByDescending(r => r.Status),
_ => asc ? query.OrderBy(r => r.CreatedAt) : query.OrderByDescending(r => r.CreatedAt),
};

query = ((IOrderedQueryable<Request>)query).ThenBy(r => r.Id);
var total = await query.CountAsync();
var items = await query.Skip((q.Page - 1) * q.PageSize).Take(q.PageSize).ToListAsync();

return new PagedResult<Request>(items, q.Page, q.PageSize, total,
(int)Math.Ceiling(total / (double)q.PageSize));
}
}
