[ApiController]
[Route("api/requests")]
public class RequestsController(AddDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll() =>
    Ok(await db.Requests.AsNoTracking()
    .Select(r => new {
        r.Id, r.Title, r.Status, r.Priority,
        Category = r.Category.Name,
        Creator = r.Creator.FullName,
        Assignee = r.Assignee != null ? r.Assignee.FullName : null,
        r.CreatedAt
    }).ToListAsync());
}
