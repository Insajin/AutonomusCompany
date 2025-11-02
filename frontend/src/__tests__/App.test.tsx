import { render, screen } from '@testing-library/react';
import App from '../App';

describe('App Component', () => {
  it('renders the app title', () => {
    render(<App />);
    const heading = screen.getByRole('heading', { level: 1 });
    expect(heading).toBeInTheDocument();
  });

  it('displays all feature items', () => {
    render(<App />);

    // Check for key features
    expect(screen.getByText(/automated code review/i)).toBeInTheDocument();
    expect(screen.getByText(/ai-assisted code fixes/i)).toBeInTheDocument();
    expect(screen.getByText(/intelligent ci\/cd/i)).toBeInTheDocument();
  });

  it('matches snapshot', () => {
    const { container } = render(<App />);
    expect(container).toMatchSnapshot();
  });
});
