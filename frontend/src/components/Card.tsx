interface CardProps {
  title: string;
  icon?: React.ReactNode;
  children: React.ReactNode;
}

export const Card: React.FC<CardProps> = ({ title, icon, children }) => (
  <div className="bg-gray-800 border border-gray-700 rounded-lg overflow-hidden">
    <div className="px-4 py-3 border-b border-gray-700 flex items-center gap-2">
      {icon && <span>{icon}</span>}
      <h3 className="font-semibold text-white">{title}</h3>
    </div>
    <div className="p-4">{children}</div>
  </div>
);
