public enum RequestStatus {Open, InProgrees, Closed}
public enum Priority {Low, Medium, High}
public class Request 
{
    public int Id { get, set }
    public string Title { get, set } = "";
    public RequestStatus Status { get, set }
    public Priority Priority { get, set }
    public DateTime CreatedAt { get, set }
}
