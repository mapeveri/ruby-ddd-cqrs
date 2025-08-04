type Props = {
  isOwn: boolean;
  text: string;
};

export default function Message({ isOwn, text }: Props) {
  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`max-w-[70%] px-5 py-3 rounded-xl text-white break-words
          ${isOwn ? 'bg-indigo-600 rounded-br-none shadow-md' : 'bg-white text-gray-900 rounded-bl-none shadow-sm'}
        `}
        style={{ wordBreak: 'break-word' }}
      >
        {text}
      </div>
    </div>
  );
}
