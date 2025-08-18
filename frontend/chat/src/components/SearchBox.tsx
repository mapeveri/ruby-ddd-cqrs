import { useState } from "react";

type SearchBoxProps = {
  chatId: string;
};

export default function SearchBox({ chatId }: SearchBoxProps) {
  const [query, setQuery] = useState("");
  const [response, setResponse] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!query.trim()) return;

    setLoading(true);
    setResponse("");

    try {
      const res = await fetch(`/api/v1/messages/search/${chatId}?q=${encodeURIComponent(query)}`);
      if (!res.ok) throw new Error("Failed to fetch search results");

      const data = await res.json();
      setResponse(data.response);
    } catch (err) {
      console.error(err);
      setResponse("Error retrieving answer");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-4 bg-white border-t border-gray-300 shadow-inner">
      <form onSubmit={handleSearch} className="flex gap-2">
        <input
          type="text"
          value={query}
          placeholder="Ask something about this chat..."
          onChange={(e) => setQuery(e.target.value)}
          className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring text-black  focus:ring-indigo-200"
        />
        <button
          type="submit"
          className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
          disabled={loading}
        >
          {loading ? "Searching..." : "Ask"}
        </button>
      </form>

      {response && (
        <div className="mt-3 p-3 bg-indigo-50 border border-indigo-200 rounded-lg text-gray-800">
          <strong>Answer:</strong> {response}
        </div>
      )}
    </div>
  );
}
